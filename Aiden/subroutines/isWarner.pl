# isWarner.pl

sub isWarner {
	my $client = shift;

	# Check the warnlist.
	open (WARNERS, "./data/warners.txt");
	my @data = <WARNERS>;
	close (WARNERS);
	chomp @data;

	foreach my $line (@data) {
		if ($client eq $line) {
			return 1;
		}
	}

	return 0;
}
1;