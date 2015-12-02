# Some jerk just warned us.

sub aim_evil {
	my ($aim,$level,$from) = @_;

	my $sn = &normalize($aim->screenname);

	print &timestamp . "\n"
		. "AidenAIM: $sn has been warned to $level\%! ";

	if (defined $from) {
		print "$from did this to me!\n"
			. "Adding $from to warners list...\n\n";

		$from = lc($from);
		$from =~ s/ //g;
		$client = join ('-','AIM',$from);

		if (-e "./data/warners.txt") {
			open (ADD, ">>./data/warners.txt");
			print ADD "\n$client";
			close (ADD);
		}
		else {
			open (NEW, ">./data/warners.txt");
			print NEW $client;
			close (NEW);
		}
	}
	else {
		print "This was done anonymously!\n\n";
	}
}
1;