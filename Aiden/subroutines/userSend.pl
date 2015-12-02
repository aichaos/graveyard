# userSend.pl - send to a user's profile.

sub userSend {
	my ($client,$var,$value) = @_;

	return 0 unless -e "./clients/$client\.usr";

	open (USR, "./clients/$client\.usr");
	my @data = <USR>;
	close (USR);
	chomp @data;

	my @new = ();
	my $found = 0;
	foreach my $line (@data) {
		my ($what,$is) = split(/=/, $line, 2);
		$what = lc($what);
		$what =~ s/ //g;

		if ($what eq $var) {
			$found = 1;
			$line = "$var=$value";
		}

		push (@new,$line);
	}

	if ($found == 0) {
		push (@new,"$var=$value");
	}

	$aiden->{clients}->{$client}->{$var} = $value;

	open (NEW, ">./clients/$client\.usr");
	print NEW join("\n",@new);
	close (NEW);

	return 1;
}
1;