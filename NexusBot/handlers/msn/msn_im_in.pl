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
# MSN Handler: im_in                            #
# Description: Handles incoming messages.       #
#################################################

sub msn_im_in {
	my ($msn,$client,$name,$msg) = @_;

	# Get the MSN handle and the local time.
	my $screenname = $msn->GetMaster->{Handle};
	my $time = localtime();

	# Format the client's e-mail address.
	$client = lc($client);
	$client =~ s/ //g;

	# Save an HTML copy of the message (assuming they used HTML)
	my $hmsg = $msg;

	# Filter the message for HTML.
	$msg =~ s/<(.|\n)+?>//g;

	# Save the unfiltered message.
	my $omsg = $msg;

	# Let's see if this person is blocked.
	my $blocked = isBlocked ($client);

	# If they're not blocked, continue.
	if ($blocked == 0) {
		# See if this message is a command.
		my ($is_command,$reply) = commands ($msn,$client,$msg,"MSN");

		# If it's not a command, continue.
		if ($is_command == 0 && $chaos->{users}->{$client}->{mute} != 1) {
			# Filter the message out.
			$msg = filter($msg);

			# Send the message to the brain.
			$reply = brain ($client,$msg,$omsg,"MSN",1);
		}

		# Get the MSN font.
		my ($font_name,$font_color) = get_msn_font ($screenname);

		# Remove HTML from the reply.
		$reply =~ s/<(.|\n)+?>//g;

		# Send the message.
		if ($reply ne "notcommand" && $reply ne "noreply") {
			# If they're not muted.
			if ($chaos->{users}->{$client}->{mute} != 1 && $chaos->{msn}->{chat} ne $msn) {
				$msn->sendtyping();
				sleep(1);
				$msn->sendmsg ($reply,Font => "$font_name",Color => "$font_color");
			}
			else {
				$reply = "noreply (muted)";
			}
		}

		# Log this IM.
		&log_im ($client,$omsg,$screenname,$reply,"ChaosMSN");
	}
}
1;