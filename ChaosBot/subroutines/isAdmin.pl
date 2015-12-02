# Subroutine: isAdmin
# Sees if the user is an admin or not.

sub isAdmin {
	# Get needed variables from the shift.
	my $client = shift;

	# Open the Admins list.
	open (ADMIN, "./data/authority/admin.txt");
	my @admins = <ADMIN>;
	close (ADMIN);

	# Initially, they're not an admin.
	my $admin = 0;

	# Go through the list.
	foreach $line (@admins) {
		chomp $line;
		$line =~ s/ //g;
		$line = lc($line);

		if ($client eq $line) {
			$admin = 1;
		}
	}

	# Return if they're an admin.
	return $admin;
}
1;