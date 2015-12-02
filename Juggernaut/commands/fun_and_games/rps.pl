#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !rps
#    .::   ::.     Description // Rock, Paper, Scissors.
# ..:;;. ' .;;:..        Usage // !rps <choice>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub rps {
	my ($self,$client,$msg,$listener) = @_;

	# If they are challenging us.
	if ($msg) {
		# Remove spaces, they're not needed.
		$msg =~ s/ //g;

		# If they're stopping...
		if ($msg eq "exit") {
			delete $chaos->{_users}->{$client}->{callback};
			return "Okay, we're done for now.";
		}

		# Only three values accepted.
		my $value;

		$value = "rock" if $msg eq "rock";
		$value = "rock" if $msg eq "r";
		$value = "paper" if $msg eq "paper";
		$value = "paper" if $msg eq "p";
		$value = "scissors" if $msg eq "scissors";
		$value = "scissors" if $msg eq "s";

		if ($value) {
			# Our value.
			my $choice = int(rand(3)) + 1;
			$choice = "rock" if $choice == 1;
			$choice = "paper" if $choice == 2;
			$choice = "scissors" if $choice == 3;

			$reply = "<b>Rock, Paper, Scissors</b>\n\n"
				. "You chose: $value\n"
				. "I chose: $choice\n\n";

			# See who wins.
			if ($value eq $choice) {
				&point_manager ($client,$listener,'+',1);
				$reply .= "Draw! You get 1 point.";
			}
			elsif ($value eq "rock" && $choice eq "paper") {
				$reply .= "Paper defeats rock. I win!";
			}
			elsif ($value eq "paper" && $choice eq "rock") {
				&point_manager ($client,$listener,'+',2);
				$reply .= "Paper defeats rock. You win! You get 2 points.";
			}
			elsif ($value eq "rock" && $choice eq "scissors") {
				&point_manager ($client,$listener,'+',2);
				$reply .= "Rock smashes scissors. You win! You get 2 points.";
			}
			elsif ($value eq "scissors" && $choice eq "rock") {
				$reply .= "Rock smashes scissors. I win!";
			}
			elsif ($value eq "paper" && $choice eq "scissors") {
				$reply .= "Scissors cut paper. I win!";
			}
			elsif ($value eq "scissors" && $choice eq "paper") {
				&point_manager ($client,$listener,'+',2);
				$reply .= "Scissors cut paper. You win! You get 2 points.";
			}
			else {
				$reply .= "(Error in deciding the winner!)";
			}
		}
		else {
			$reply = "Value options are: rock, paper, or scissors.";
		}
	}
	else {
		$reply = "<b>Rock, Paper, Scissors</b>\n\n"
			. "To play, type a choice from below.\n\n"
			. "Valid choices [shortcuts]\n"
			. "rock [r]\n"
			. "paper [p]\n"
			. "scissors [s]\n\n"
			. "Type \"exit\" when you want to stop.";

		# Set a callback for ease of use.
		$chaos->{_users}->{$client}->{callback} = "rps";
	}

	return $reply;
}

{
	Category => 'Fun & Games',
	Description => 'Rock, Paper, Scissors',
	Usage => '!rps <choice>',
	Listener => 'All',
};