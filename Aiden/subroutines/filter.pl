# filter.pl

sub filter {
	my $string = shift;

#	print "\t\tFilter Sub Called\n"
#		. "\t\t\tIn: $string\n";

	$string = lc($string);

#	print "\t\t\tLC: $string\n"
#		. "\t\t\tGoing through subs...\n";

	my @words = split(/\s+/, $string);
	my @new = ();
	foreach my $word (@words) {
		if (exists $aiden->{subs}->{$word}) {
			$word = $aiden->{subs}->{$word};
		}
		push (@new,$word);
	}

	########################################################################
	# The following code was broken on non-letter words like :-) and other #
	# such emoticons.                                                      #
	########################################################################

	# Perform substitutions.
#	foreach my $sub (keys %{$aiden->{subs}}) {
#		my $orig = $sub;
#		$sub =~ s/([^A-Za-z0-9 ])/\\$1/g;
#
#		my $sleep = 0;
#		$sleep = 1 if $orig eq ':-)';
#
#		$string =~ s/\b$sub\b/$aiden->{subs}->{$orig}/g;
#
#		print "\t\t\t\tOrig: $orig\n"
#			. "\t\t\t\t\tSub: $aiden->{subs}->{$orig}\n"
#			. "\t\t\t\t\tString: $string\n";
#
#		sleep($sleep);
#	}

	# Remove punctuation and such.
	$string = join (" ", @words);
#	print "\t\t\tRemoving punctuation\n";

	foreach my $any (@{$aiden->{subanywhere}}) {
		my $in = $any;
		my $out = $aiden->{subs}->{$in} or next;
		$in =~ s/([^A-Za-z0-9 _:=<>])/\\$1/g;
		$string =~ s/$in/$out/ig;
	}

	$string =~ s/[^A-Za-z0-9 ]//g;
	$string =~ s/^\s//g;
	$string =~ s/\s$//g;

#	print "\t\t\tFinal String: $string\n";

	return $string;
}
1;