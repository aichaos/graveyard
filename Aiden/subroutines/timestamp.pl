# timestamp.pl - Get a TimeStamp.

sub timestamp {
	my $stamp = $aiden->{config}->{time};

	return time_format ($stamp);
}
1;