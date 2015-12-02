# AIM Handler: im_in
# Handles incoming Instant Messages.

sub aim_im_in {
	# Get server arguments from the shift.
	my ($aim,$client,$msg,$away) = @_;

	# There are no special logging cases.
	$log_im = "plain";

	# Get the local time.
	my $time = localtime();

	# Get a reference to the current bot's screenname.
	my $screenname = $aim->screenname();

	# Format the client's name to how you should want it (no spaces, lowercase).
	$client = lc($client);
	$client =~ s/ //g;

	# Save an HTML copy of the message in case we need it later.
	my $hmsg = $msg;

	# Filter the message for HTML.
	$msg =~ s/<(.|\n)+?>//g;

	# Save a copy of the unfiltered message.
	my $omsg = $msg;

	# See if this idiot is a warner.
	my $is_a_warner = warners ($aim,$client);

	# See if this person is blocked.
	my $is_blocked = blocked ($client);

	# If they are not a warner OR blocked, continue.
	if ($is_a_warner == 0 && $is_blocked == 0) {
		# Compare this message against our commands.
		($is_a_command,$reply) = commands($client,$msg,$aim);

		# If it's not a command... continue.
		if ($is_a_command == 0 && $is_away == 0) {
			# Filter the message for punctuation.
			$msg = filter($msg);

			# This is where the bot gets a reply to your message.
			# Right now, it's setup to use our learning code.
			$reply = respond ($client,$msg,$omsg,$aim);
		}

		# If we have a response, send an IM back.
		if ($reply ne "noreply" && $reply ne "notcommand" && $is_away == 0) {
			# Sleep a bit before sending.
			sleep (dosleep(1,3));

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
			&aol_im ($client,$reply,$aim);
		}

		# Log this IM if there are no special cases.
		&log_im ($client,$omsg,$screenname,$reply,$log_im,"ChaosAIM");
	}
}
1;