#      .   .               <Leviathan>
#     .:...::     Command Name // !points
#    .::   ::.     Description // See how many points you have.
# ..:;;. ' .;;:..        Usage // !points
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub points {
	my ($self,$client,$msg) = @_;

	# A sub-command?
	$msg = lc($msg); $msg =~ s/ //g;
	if ($msg eq "list") {
		return "<body bgcolor=\"#FFFFFF\"><font face=\"Verdana\" size=\"2\" color=\"#000000\">"
			. "<b><u>:: List of Games ::</u></b>\n\n"
			. "The following games can be played to earn points:\n\n"
			. "<b>:: Hangman - !hang</b>\n"
			. "15 points if you guess the word first\n"
			. "10 points if you made 1 move\n"
			. "8 points for 2 moves\n"
			. "6 points for 3 moves\n"
			. "4 points for 4 moves\n"
			. "2 points for more than 4 moves\n"
			. "You can earn 5 extra points for not guessing any vowels\n\n"
			. "<b>:: Rock Paper Scissors - !rps</b>\n"
			. "Earn 10 points for winning\n"
			. "Lose 10 points for losing\n\n"
			. "<b>:: Guess My Number - !guess</b>\n"
			. "+10 points for Level 1\n"
			. "+25 points for Level 2\n"
			. "+50 points for Level 3\n"
			. "+250 points for Level 4\n"
			. "+15,000 points for Level 5\n\n"
			. "<b>:: Zener Cards - !zener</b>\n"
			. "Must get more than 5 right, you get <i>10 to the power of X</i> points, where X "
			. "is how many (more than 5) you got correct.</font></body>";
	}

	# Get their points.
	my $points = $chaos->{clients}->{$client}->{points};

	return "Unknown error. Please wait until I am rebooted." unless length $points > 0;

	return "<body bgcolor=\"#FFFFFF\"><font face=\"Verdana\" size=\"2\" color=\"#000000\"><b>:: Your Points ::</b>\n\n"
		. "You currently have <b>$points</b> points.\n\n"
		. "You can earn points by playing dynamic games such as hangman or tic-tac-toe. (games like madlibs doesn't count).\n\n"
		. "Type \"!points list\" for a list of games that you can earn points on.</font></body>";
}

{
	Category => 'Bot Utilities',
	Description => 'Check your points.',
	Usage => '!points [list]',
	Listener => 'All',
};