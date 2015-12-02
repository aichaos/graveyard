# userGet.pl - load a user's profile.

sub userGet {
	my $client = shift;

	return 0 unless -e "./clients/$client\.usr";

	open (USR, "./clients/$client\.usr");
	my @data = <USR>;
	close (USR);
	chomp @data;

	foreach my $line (@data) {
		my ($what,$is) = split(/=/, $line, 2);
		$what = lc($what);
		$what =~ s/ //g;

		$aiden->{clients}->{$client}->{$what} = $is;
	}

	return 1;
}
1;