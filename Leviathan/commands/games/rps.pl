#      .   .               <Leviathan>
#     .:...::     Command Name // !rps
#    .::   ::.     Description // Rock, Paper, Scissors
# ..:;;. ' .;;:..        Usage // !rps
#    .  '''  .     Permissions // Public.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub rps {
	my ($self,$client,$msg) = @_;

	# Set the callback.
	$chaos->{clients}->{$client}->{callback} = 'rps';

	# Exiting?
	if ($msg =~ /^exit$/i) {
		delete $chaos->{clients}->{$client}->{callback};
		return "We're done playing Rock, Paper, Scissors.";
	}

	# No message?
	if (length $msg == 0) {
		return ":: Rock, Paper, Scissors ::\n\n"
			. "Type \"rock\", \"paper\", or \"scissors\" to play (you can also "
			. "type r, p, or s for shortcuts).";
	}

	# Conversations.
	$msg = lc($msg); $msg =~ s/ //g;
	$msg = 'rock'     if $msg eq 'r';
	$msg = 'paper'    if $msg eq 'p';
	$msg = 'scissors' if $msg eq 's';

	# Must be one of the three options.
	if ($msg =~ /^(rock|paper|scissors)$/i) {
		# The computer picks one.
		my @choices = qw (rock paper scissors);
		my $pick = $choices [ int(rand(scalar(@choices))) ];

		my %possible = (
			# human-comp.       => outcome
			'rock-rock'         => 'draw',
			'rock-paper'        => 'lose',
			'rock-scissors'     => 'win',
			'paper-rock'        => 'win',
			'paper-paper'       => 'draw',
			'paper-scissors'    => 'lose',
			'scissors-rock'     => 'lose',
			'scissors-paper'    => 'win',
			'scissors-scissors' => 'draw',
		);

		# See which one it is.
		foreach my $key (keys %possible) {
			my ($human,$cpu) = split(/\-/, $key, 2);

			if ($human eq $msg && $cpu eq $pick) {
				# See who won.
				if ($possible{$key} eq 'win') {
					# Earn 10 points for winning.
					&modPoints ($client,'+',10);
					return ":: Rock Paper Scissors ::\n\n"
						. "You picked: $msg\n"
						. "I picked: $pick\n\n"
						. "$human beats $cpu. You win!\n"
						. "You won 10 points this round.";
				}
				elsif ($possible{$key} eq 'lose') {
					# Lose 10 points for losing.
					&modPoints ($client,'-',10);
					return ":: Rock Paper Scissors ::\n\n"
						. "You picked: $msg\n"
						. "I picked: $pick\n\n"
						. "$cpu beats $human. You lose!\n"
						. "You have lost 10 points this round.";
				}
				else {
					return ":: Rock Paper Scissors ::\n\n"
						. "You picked: $msg\n"
						. "I picked: $pick\n\n"
						. "They are both equal. Draw!\n"
						. "You didn't lose or gain points from this round.";
				}
			}
		}

		return "ERR: Unknown error.";
	}
	else {
		return "You can only pick from these options:\n\n"
			. "rock [r]\n"
			. "paper [p]\n"
			. "scissors [s]\n\n"
			. "Type \"exit\" to quit playing.";
	}
}
{
	Category    => 'Single-Player Games',
	Description => 'Rock, Paper, Scissors',
	Usage       => '!rps <choice>',
	Listener    => 'All',
};