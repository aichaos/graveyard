# COMMAND NAME:
#	BUG
# DESCRIPTION:
#	Report bugs in the program.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub bug {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure they are mentioning a bug.
	if ($msg) {
		if ($msg eq "read") {
			# Reading the bugs. Only the Master needs to do this.
			if (isMaster($client,$listener)) {
				if (-e "./data/bugs.txt" == 1) {
					open (LIST, "./data/bugs.txt");
					my @list = <LIST>;
					close (LIST);

					chomp @list;

					$reply = "Bugs that have been reported:\n\n";

					my $count = 1;
					foreach $line (@list) {
						if ($line ne "") {
							$reply .= "<b>$count</b>) $line\n";
							$count++;
						}
					}
				}
				else {
					$reply = "No new bugs have been reported.";
				}
			}
			else {
				$reply = "Only the botmaster may view the reported bugs.";
			}
		}
		elsif ($msg eq "clear") {
			# Clearing the bugs. Make sure they're the Master.
			if (isMaster($client,$listener)) {
				unlink ("./data/bugs.txt");

				$reply = "I have cleared the bugs file.";
			}
			else {
				$reply = "Only the botmaster may delete the bug files.";
			}
		}
		else {
			# Save this bug.
			open (BUG, ">>./data/bugs.txt");
			print BUG "$msg\n";
			close (BUG);

			$reply = "I have reported the bug.";
		}
	}
	else {
		$reply = "You must report a bug (error or glitch).\n\n"
			. "!bug [report]";
	}

	return $reply;
}
1;