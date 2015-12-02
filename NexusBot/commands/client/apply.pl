# COMMAND NAME:
#	APPLY
# DESCRIPTION:
#	Apply for higher authority!
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub apply {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure they have a position in mind.
	if ($msg) {
		$msg = lc($msg);
		my $desire;

		$desire = "Keeper" if $msg eq "keeper";
		$desire = "Gifted" if $msg eq "gifted";
		$desire = "Moderator" if $msg eq "moderator";
		$desire = "Super Moderator" if $msg eq "super moderator";
		$desire = "Admin" if $msg eq "admin";
		$desire = "Super Admin" if $msg eq "super admin";

		if ($desire) {
			# Apply them.
			open (APPLY, ">>./data/applications.txt");
			print APPLY "$client applied for $desire\n";
			close (APPLY);

			$reply = "I have left the application. It will be reviewed shortly.";
		}
		else {
			if ($msg eq "read") {
				# Reading the application form. Only the Master can promote users.
				if (isMaster($client,$listener)) {
					if (-e "./data/applications.txt" == 1) {
						open (LIST, "./data/applications.txt");
						my @applications = <LIST>;
						close (LIST);

						chomp @applications;

						$reply = "Current applications pending:\n\n";

						my $count = 1;
						foreach $line (@applications) {
							if ($line ne "") {
								$reply .= "<b>$count</b>) $line\n";
								$count++;
							}
						}
					}
					else {
						$reply = "There are no new applications.";
					}
				}
				else {
					$reply = "Only the botmaster can read or promote users.";
				}
			}
			elsif ($msg eq "clear") {
				# Clearing data, only Master can do this.
				if (isMaster($client,$listener)) {
					unlink ("./data/applications.txt");

					$reply = "I have cleared the applications.";
				}
				else {
					$reply = "Only the botmaster can clear applications.";
				}
			}
			else {
				$reply = "Invalid position. Valid positions are:\n"
					. "Keeper, Gifted, Moderator, Super Moderator, "
					. "Admin, Super Admin.";
			}
		}
	}
	else {
		$reply = "Correct usage is: !apply [position]\n\n"
			. "Valid positions are:\n"
			. "Keeper, Gifted, Moderator, Super Moderator, Admin, Super Admin.";
	}

	return $reply;
}
1;