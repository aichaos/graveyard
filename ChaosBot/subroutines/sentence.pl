# Subroutine: sentence
# Turn a string into Sentence Case.

sub sentence {
	# Get the string to be converted from the shift.
	my $string = shift;

	# Set our starting variables.
	my $in_a_sentence = 0;

	# Split the message.
	my @chars = split(//, $string);

	# Go through each one.
	my $complete;
	foreach $item (@chars) {
		if ($in_a_sentence == 0) {
			if ($item ne " ") {
				$item = uc($item);
				$in_a_sentence = 1;
			}
		}
		else {
			if ($item eq "\." || $item eq "\?" || $item eq "\!") {
				$in_a_sentence = 0;
			}
			else {
				$item = lc($item);
			}
		}
		$complete .= $item;
	}

	# Return the fixed message.
	return $complete;
}
1;