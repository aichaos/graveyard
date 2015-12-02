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
# AIM Handler: chat_im_in                       #
# Description: Handles incoming IM's.           #
#################################################

sub aim_chat_im_in {
	my ($aim,$client,$chat,$msg) = @_;

	# Get the screenname and local time.
	my $screenname = $aim->screenname();
	my $time = localtime();

	# Format the client's screenname.
	$client =~ s/ //g;
	$client = lc($client);

	# Save an HTML copy of the message.
	my $hmsg = $msg;

	# Format the message for HTML.
	$msg =~ s/<(.|\n)+?>//g;

	# Save an unformatted copy of the message.
	my $omsg = $msg;

	# Lowercase the message.
	$msg = lc($msg);

	my $blocked = 0;

	# If they're neither, continue.
	if ($blocked == 0) {
		# Check this against the list of commands.
		my ($is_command,$reply) = commands ($aim,$client,$msg,"AIM");

		# If it's not a command.
		if ($is_command == 0) {
			# See if they're talking directly to the bot.
			if ($msg =~ /^$screenname/i || $msg =~ /$screenname$/i) {
				$msg =~ s/$screenname //ig;
				$msg =~ s/ $screenname//ig;

				# Filter the message out.
				$msg = filter($msg);

				# Send the message to the brain.
				$reply = brain ($client,$msg,$omsg,"AIM",1);
			}
		}

		# If there's a reply to send.
		if ($reply ne "") {
			# Get the AIM font.
			my $font = get_aim_font ($screenname);

			# Sleep a bit before sending.
			sleep(2);

			# Send the message.
			if ($reply ne "notcommand" && $reply ne "noreply") {
				$reply =~ s/\n/<br>/ig;
				$reply = ($font . $reply);

				$aim->chat_send ($chat, $reply, 1);
			}

			# Log this IM.
			print "[From a chatroom]\n";
			&log_im ($client,$omsg,$screenname,$reply,"ChaosAIM");
		}
		else {
			print "[From a chatroom]\n";
			print "$time\n";
			print "ChaosAIM: [$client] $msg\n\n";
		}
	}
	else {
		print "[From a chatroom]\n";
		print "$time\n";
		print "ChaosAIM: [$client] ";
		if (isWarner($client)) {
			print "<warner>";
		}
		if (isBlocked($client)) {
			print "<blocked>";
		}
		print " $msg\n\n";
	}
}
1;