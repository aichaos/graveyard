# normalize.pl - Normalize a string.

sub normalize {
	my $string = shift;
	$string = lc($string);
	$string =~ s/ //g;
	return $string;
}
1;