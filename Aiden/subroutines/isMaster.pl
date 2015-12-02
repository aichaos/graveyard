# isMaster.pl - checks if a user's the botmaster.

sub isMaster {
	my $client = shift;

	open (MASTER, "./data/botmasters.txt");
	my @data = <MASTER>;
	close (MASTER);
	chomp @data;

	foreach my $line (@data) {
		if ($line eq $client) {
			return 1;
		}
	}

	return 0;
}
1;