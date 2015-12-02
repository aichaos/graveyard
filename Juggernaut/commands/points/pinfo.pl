#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !pinfo
#    .::   ::.     Description // Points information.
# ..:;;. ' .;;:..        Usage // !pinfo
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub pinfo {
	my ($self,$client,$msg,$listener) = @_;

	# If they're querying something.
	if (length $msg > 0) {
		delete $chaos->{_users}->{$client}->{callback};

		if ($msg eq "exit") {
			return "Byebye!";
		}
		elsif ($msg eq "hangman") {
			return "HangMan: !hang\n\n"
				. "Points - Description\n"
				. "+15 - Bonus - Guess the word first\n"
				. "+10 - Guess word after choosing 1 letter\n"
				. "+8 - Guess after 2 letters\n"
				. "+6 - Guess after 3 letters\n"
				. "+4 - Guess after 4 letters\n"
				. "+2 - Guess after 5 or more letters\n\n"
				. "Bonus Points:\n"
				. "+1 point for every vowel not chosen\n\n"
				. "Catches:\n"
				. "If you choose every single letter of the word, you get no points.";
		}
		elsif ($msg eq "tic tac toe") {
			return "Tic Tac Toe: !ttt\n\n"
				. "Earning Points:\n"
				. "+1* - One point for every X placed on the board\n\n"
				. "Catches:\n"
				. "If you lose or the game ends in a draw, you get no points.";
		}
		elsif ($msg eq "rock paper scissors") {
			return "Rock Paper Scissors: !rps\n\n"
				. "Earning Points:\n"
				. "+2 - If you win\n"
				. "+1 - If it's a draw\n\n"
				. "Catches:\n"
				. "You get no points if you lose.";
		}
		elsif ($msg eq "guess my number") {
			return "Guess My Number: !guess\n\n"
				. "Earning Points:\n"
				. "+20 - Win on Insane Mode (1-100)\n"
				. "+10 - Win on Hard Mode (1-50)\n"
				. "+6 - Win on Normal Mode (1-20)\n"
				. "+4 - Win on Easy Mode (1-10)\n"
				. "+2 - Win on Simple Mode (1-5)\n\n"
				. "Catches:\n"
				. "You get no points if you lose.";
		}
		elsif ($msg eq "slots") {
			return "Slot Machines: !slots\n\n"
				. "Earning Points:\n"
				. "+* - However much points you earn from the slots themselves, "
				. "this amount is added to how much you betted, and the grand total "
				. "is added to your point count.\n\n"
				. "Catches:\n"
				. "Likewise, if your result is a negative number, you will lose how "
				. "much you betted plus the result from the slots.";
		}
		else {
			return "Invalid category name. Type !pinfo for a list of categories.";
		}
	}
	else {
		$chaos->{_users}->{$client}->{callback} = "pinfo";
		return "Welcome to the Points Information Center!\n\n"
			. "The prime way of earning points is by playing games. Type "
			. "the name of a game from the list below for information. Type "
			. "'exit' to leave:\n\n"
			. "hangman\n"
			. "tic tac toe\n"
			. "rock paper scissors\n"
			. "guess my number\n"
			. "slots";
	}
}

{
	Category => 'Points Earning',
	Description => 'Points Information',
	Usage => '!pinfo',
	Listener => 'All',
};