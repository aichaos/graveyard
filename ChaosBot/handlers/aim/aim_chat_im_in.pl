# AIM Handler: chat_im_in
# Handles incoming chat messages.

sub aim_chat_im_in {
	# Get server arguments from the shift.
	my ($aim,$client,$chat,$msg) = @_;

	my $time = localtime();

	my $screenname = $aim->screenname();
	$screenname = lc($screenname);

	# Filter the message for HTML.
	$msg =~ s/<(.|\n)+?>//g;

	# If we are being talked to...
	if ($msg =~ /^$screenname/i || $msg =~ /$screenname$/i) {
		$msg =~ s/$screenname //ig;
		$msg =~ s/ $screenname//ig;
		# No special logging cases.
		$log_im = "plain";

		# Format the client's name.
		$client = lc($client);
		$client =~ s/ //g;

		# Save an HTML copy.
		my $msg = $msg;

		# Save a copy of the unfiltered message.
		my $omsg = $msg;

		# If this person is a warner or is blocked, ignore it.
		my $is_a_warner = warners ($aim,$client);
		my $is_blocked = blocked ($client);

		# If they're okay, continue.
		if ($is_a_warner == 0 && $is_blocked == 0) {
			# Compare the message against some commands.
			($is_a_command,$reply) = commands($client,$msg,$aim);

			# If it's not a command... continue.
			if ($is_a_command == 0) {
				# Filter the message for punctuation.
				$msg = filter($msg);

				# This is where the bot gets a reply to
				# the message.
				$reply = respond ($client,$msg,$omsg,$aim);
			}

			# If we have a response, send it in chat.
			if ($reply ne "noreply" && $reply ne "notcommand") {
				# Sleep a bit before sending.
				sleep(dosleep(1,3));

				# Format the reply to get the AIM font.
				open (FONT, "./data/aim/font.txt");
				my @font = <FONT>;
				close (FONT);
				foreach $line (@font) {
					chomp $line;
					$font .= $line;
				}
				$reply = ($font . $reply);

				# Send the message.
				$aim->chat_send ($chat,$reply,1);

				# Log the IM.
				&log_im ($client,$omsg,$screenname,$reply,$log_im,"ChaosAIM");
			}
		}
	}
	else {
		print "$time\n";
		print "From chatroom $chat\n";
		print "[$client] $msg\n\n";
	}
}
1;