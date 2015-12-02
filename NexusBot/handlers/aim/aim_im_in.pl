#################################################
#                                               #
#     #####    #                                #
#    #     #   #                                #
#   #       #  #                                #
#  #           #            #                   #
#  #           ####     #####     ####    ####  #
#  #           #   #   #    #    #    #  #      #
#   #       #  #    #  #    #    #    #   ###   #
#    #     #   #    #  #    #    #    #      #  #
#     #####    #    #   #### ##   ####   ####   #
#                                               #
#         A . I .      T e c h n o l o g y      #
#-----------------------------------------------#
# AIM Handler: im_in                            #
# Description: Handles incoming IM's.           #
#################################################

sub aim_im_in {
	my ($aim,$client,$msg,$away) = @_;

	# Get the screenname and local time.
	my $screenname = $aim->screenname();
	my $time = localtime();

	# Format the user's screenname (remove spaces, lowercase).
	$client = lc($client);
	$client =~ s/ //g;

	# Save an HTML copy of the message (you never know, we may need it)
	my $hmsg = $msg;

	# Filter HTML from the message.
	$msg =~ s/<(.|\n)+?>//g;

	# Save an unfiltered copy of the message.
	my $omsg = $msg;

	# Now, let's check out a few things...
	my $warner = isWarner ($aim,$client); # 1. If they're a warner.
	my $block = isBlocked ($client);      # 2. If they're blocked.

	# If they're not a warner or blocked, continue.
	if ($warner == 0 && $block == 0) {
		# See if this message is a command.
		my ($is_command,$reply) = commands ($aim,$client,$msg,"AIM",1);

		# If it's not a command, continue.
		if ($is_command == 0 && $chaos->{users}->{$client}->{mute} != 1) {
			# Filter the message out.
			$msg = filter($msg);

			# Send the message to the brain.
			$reply = brain ($client,$msg,$omsg,"AIM",1);
		}

		my $font = get_aim_font ($screenname);

		# Sleep a bit before sending.
		sleep(2);

		# Send the message.
		if ($reply ne "notcommand" && $reply ne "noreply") {
			# If they're not muted.
			if ($chaos->{users}->{$client}->{mute} != 1) {
				$reply =~ s/\n/<br>/ig;
				$reply = ($font . $reply);

				$aim->send_im ($client, $reply) if $reply ne "notcommand";
			}
			else {
				$reply = "noreply (muted)";
			}
		}

		# Log this IM.
		&log_im ($client,$omsg,$screenname,$reply,"ChaosAIM");
	}
}
1;