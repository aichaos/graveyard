#      .   .               <Leviathan>
#     .:...::     Command Name // !guess
#    .::   ::.     Description // Guess My Number
# ..:;;. ' .;;:..        Usage // !guess <difficulty> <number>
#    .  '''  .     Permissions // Public.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub guess {
	my ($self,$client,$msg) = @_;

	# Must provide a message.
	if (length $msg > 0) {
		# Get data from it.
		my ($dif,$num) = split(/\s+/, $msg, 2);

		if ($dif =~ /^(0|1|2|3|4|5)$/i) {
			# Number must be numeric.
			return "The number isn't numeric!" if $num =~ /[^0-9]/i;

			# Pick a number.
			my $number = 1;
			$number = int(rand(5))    if $dif == 0;
			$number = int(rand(10))   if $dif == 1;
			$number = int(rand(25))   if $dif == 2;
			$number = int(rand(50))   if $dif == 3;
			$number = int(rand(100))  if $dif == 4;
			$number = int(rand(1000)) if $dif == 5;
			$number++;

			# If they guessed correctly...
			if ($msg == $number) {
				# They won! Give them their points.
				my $points = 0;
				$points = 10    if $dif == 1;
				$points = 25    if $dif == 2;
				$points = 50    if $dif == 3;
				$points = 100   if $dif == 4;
				$points = 15000 if $dif == 5;

				if ($points > 0) {
					&modPoints($client,'+',$points);
				}

				return "You guessed my number correctly!\n\n"
					. "You have earned $points points.";
			}
			else {
				return "Nope, that's not my number. My number was $number. "
					. "Keep trying!";
			}
		}
		else {
			return "Provide a difficulty level and a number when using this command.\n\n"
				. "Difficulty levels:\n"
				. "0: Guess from 1-5\n"
				. "1: Guess from 1-10 (earns 10 points)\n"
				. "2: Guess from 1-25 (earns 25 points)\n"
				. "3: Guess from 1-50 (earns 50 points)\n"
				. "4: Guess from 1-100 (earns 250 points)\n"
				. "5: Guess from 1-1,000 (earns 15,000 points)\n\n"
				. "Proper use:\n"
				. "!guess <lt>difficulty<gt> <lt>number to guess<gt>\n\n"
				. "Examples of use:\n"
				. "!guess 0 6\n"
				. "!guess 5 467";
		}
	}
	else {
		return "Proper usage:\n\n"
			. "!guess <lt>difficulty<gt> <lt>number<gt>\n\n"
			. "Difficulty levels:\n"
			. "0: Guess from 1-5\n"
			. "1: Guess from 1-10 (earns 10 points)\n"
			. "2: Guess from 1-25 (earns 25 points)\n"
			. "3: Guess from 1-50 (earns 50 points)\n"
			. "4: Guess from 1-100 (earns 250 points)\n"
			. "5: Guess from 1-1,000 (earns 15,000 points)";
	}
}
{
	Category    => 'Single-Player Games',
	Description => 'Guess My Number',
	Usage       => '!guess <difficulty> <number>',
	Listener    => 'All',
};