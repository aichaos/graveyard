# Subroutine: dosleep
# Sleeps a bit before sending the message.

sub dosleep {
	# Get the minimum and maximum sleep times from the shift.
	my ($min,$max) = @_;

	# Create a random sleep time.
	my $sleep = rand ($max - $min);
	$sleep = $sleep + $min;

	# Return this number.
	return $sleep;
}
1;