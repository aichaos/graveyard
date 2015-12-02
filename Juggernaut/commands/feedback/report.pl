#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !report
#    .::   ::.     Description // Report an abusive user.
# ..:;;. ' .;;:..        Usage // !report <username>: <reason>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub report {
	my ($self,$client,$msg,$listener) = @_;

	my $l = $listener;

	# Split the username and the message to report about them.
	$msg =~ s/: /:/g;
	my ($who,$why) = split(/:/, $msg, 2);

	# If we have somebody to report...
	if ($who) {
		if ($who eq "read") {
			# Reading the reports. Make sure this person has
			# high enough authority.
			if (isMaster ($client,$l)) {
				if (-e "./data/report.txt" == 1) {
					# Open the report file.
					open (FILE, "./data/report.txt");
					my @reports = <FILE>;
					close (FILE);

					my $list;
					my $count = 0;

					foreach $line (@reports) {
						chomp $line;
						if ($line ne "") {
							my ($from,$what,$reason) = split(/=/, $line, 3);
							$count++;
							$list .= "$count. $from reported $what for $reason\n";
						}
					}

					$reply = "There were $count reports:\n\n"
						. $list;
				}
				else {
					$reply = "There are no new reports.";
				}
			}
			else {
				$reply = "You are not of great enough authority to "
					. "read the report logs.";
			}
		}
		elsif ($who eq "clear") {
			# Clearing the reports. Make sure this person has
			# high enough authority.
			if (isMaster($client,$l)) {
				unlink ("./data/report.txt");

				$reply = "I have deleted the report file.";
			}
			else {
				$reply = "You are not of great enough authority to "
					. "clear the report logs.";
			}
		}
		else {
			# If we have a reason...
			if ($why) {
				# Leave this report.
				open (REPORT, ">>./data/report.txt");
				print REPORT "$client=$who=$why\n";
				close (REPORT);

				$reply = "I have reported $who.";
			}
			else {
				# They need a reason.
				$reply = "You must report a user with a reason.\n\n"
					. "!report username: reason";
			}
		}
	}
	else {
		$reply = "To report a user, follow this format:\n\n"
			. "!report username: reason";
	}

	return $reply;
}

{
	Category => 'Feedback',
	Description => 'Report an Abusive User',
	Usage => '!report <username> : <reason>',
	Listener => 'All',
};