# COMMAND NAME:
#	GUESS
# DESCRIPTION:
#	A guessing game. Guess the number from 1 to 10.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub guess {
	# Get variables from the shift.
	my ($client,$msg,$self) = @_;

	# Cut the command off.
	$msg =~ s/\!guess //ig;

	# Choose our random number from 1 to 10.
	my $number = int(rand(10)) + 1;

	# See if they got it.
	if ($msg ne "") {
		if ($msg == $number) {
			$reply = "Yes! You got my number! :-D";
		}
		else {
			$reply = "Sorry, :-( it was $number! :-P";
		}
	}
	else {
		$reply = "You need to give me a number...\n!guess NUMBER";
	}

	return $reply;
}
1;