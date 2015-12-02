# Subroutine: isMod
# Sees if the user is an Mod or not.

sub isMod {
	# Get needed variables from the shift.
	my $client = shift;

	# Open the Mods list.
	open (MODS, "./data/authority/mods.txt");
	my @mods = <MODS>;
	close (MODS);

	# Initially, they're not a mod.
	my $mod = 0;

	# Go through the list.
	foreach $line (@mods) {
		chomp $line;
		$line =~ s/ //g;
		$line = lc($line);

		if ($client eq $line) {
			$mod = 1;
		}
	}

	# Return if they're an admin.
	return $mod;
}
1;