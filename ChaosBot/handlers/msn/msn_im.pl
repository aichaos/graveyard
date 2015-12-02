# MSN Handler: im
# Handles incoming Instant Messages.

sub msn_im {
	# Get server arguments.
	my ($msn,$client,$friendly,$msg) = @_;

	# There are no special logging cases.
	$log_im = "plain";

	# Get the local time.
	my $time = localtime();

	# Format the client's name.
	$client = lc($client);
	$client =~ s/ //g;

	# Save a copy of the original message.
	my $omsg = $msg;

	# See if this person is blocked.
	my $is_blocked = blocked ($client);

	# If they are not blocked, continue.
	if ($is_blocked == 0) {
		# Compare this message against our commands.
		($is_a_command,$reply) = commands($client,$msg,$msn);

		# If it's not a command... continue.
		if ($is_a_command == 0) {
			# Filter the message for punctuation.
			$msg = filter($msg);

			# This is where the bot gets a reply to your message.
			# Right now, it's setup to use our learning code.
			$reply = respond ($client,$msg,$omsg,$msn);
		}

		# If we have a response, send an IM back.
		if ($reply ne "noreply" && $reply ne "notcommand") {
			# Filter HTML from $reply.
			$reply =~ s/<(.|\n)+?>//g;

			# Load the MSN font.
			open (FONT, "./data/msn/font.txt");
			my @font = <FONT>;
			close (FONT);
			foreach $line (@font) {
				chomp $line;
				my ($what,$is) = split(/=/, $line);
				$what = lc($what);
				$what =~ s/ //g;

				if ($what eq "fontname") {
					$font_name = $is;
				}
				if ($what eq "fontcolor") {
					$font_color = $is;
				}
			}

			# Send typing and then the message.
			$msn->sendtyping;
			sleep(2);
			$msn->sendmsg ($reply,Font => "$font_name",Color => "$font_color");
		}

		# Log this IM if there are no special cases.
		&log_im ($client,$omsg,$screenname,$reply,$log_im,"ChaosMSN");
	}
}
1;