#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !guess
#    .::   ::.     Description // The Guess My Number Game.
# ..:;;. ' .;;:..        Usage // !guess <difficulty> <number>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub guess {
	# Get variables from the shift.
	my ($self,$client,$msg,$listener) = @_;

	# Get the difficulty and the number from the message.
	my ($level,$num) = split (/ /, $msg, 2);

	# See if they have a message.
	if (length $level > 0) {
		my $choice;
		if ($level eq "insane" || $level eq "i") {
			$choice = int(rand(100)) + 1;

			if ($num eq $choice) {
				&point_manager ($client,$listener,'+',20);
				my $emo;
				$emo = ':O' if $listener eq "MSN";
				$emo = '=-o' if $listener eq "AIM";
				return "WOW! $emo You did it! You just earned 20 points! :-D";
			}
			else {
				return "Sorry. :-( My number was $choice.";
			}
		}
		elsif ($level eq "hard" || $level eq "h") {
			$choice = int(rand(50)) + 1;

			if ($num eq $choice) {
				&point_manager ($client,$listener,'+',10);
				return "Good job! You got it! You earned 10 points. :-)";
			}
			else {
				return "Sorry. :-( My number was $choice.";
			}
		}
		elsif ($level eq "normal" || $level eq "n") {
			$choice = int(rand(20)) + 1;

			if ($num eq $choice) {
				&point_manager ($client,$listener,'+',6);
				return "Yeah! You got my number! You earned 6 points. :-)";
			}
			else {
				return "Sorry. :-( My number was $choice.";
			}
		}
		elsif ($level eq "easy" || $level eq "e") {
			$choice = int(rand(10)) + 1;

			if ($num eq $choice) {
				&point_manager ($client,$listener,'+',4);
				return "Yep! You earned 4 points.";
			}
			else {
				return "Sorry. :-( My number was $choice.";
			}
		}
		elsif ($level eq "simple" || $level eq "s") {
			$choice = int(rand(5)) + 1;

			if ($num eq $choice) {
				&point_manager ($client,$listener,'+',2);
				return "You got it! You earned 2 points.";
			}
			else {
				return "Sorry. :-( My number was $choice.";
			}
		}
		else {
			return "Invalid difficulty level. Levels are:\n\n"
				. "insane [i]: 1-100 // 20 points\n"
				. "hard [h]: 1-50 // 10 points\n"
				. "normal [n]: 1-20 // 6 points\n"
				. "easy [e]: 1-10 // 4 points\n"
				. "simple [s]: 1-5 // 2 points\n\n"
				. "Command usage:\n"
				. "!guess [difficulty] [number]";
		}
	}
	else {
		$reply = "Welcome to the Guess My Number Game! Choose a difficulty and a number to guess:\n\n"
			. "insane [i]: 1-100 // 20 points\n"
			. "hard [h]: 1-50 // 10 points\n"
			. "normal [n]: 1-20 // 6 points\n"
			. "easy [e]: 1-10 // 4 points\n"
			. "simple [s]: 1-5 // 2 points\n\n"
			. "Command usage:\n"
			. "!guess [difficulty] [number]";
	}

	return $reply;
}

{
	Category => 'Fun & Games',
	Description => 'Guess My Number Game',
	Usage => '!guess <difficulty> <number>',
	Listener => 'All',
};