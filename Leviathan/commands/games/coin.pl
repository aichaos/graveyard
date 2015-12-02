#      .   .               <Leviathan>
#     .:...::     Command Name // !coin
#    .::   ::.     Description // Flip a coin.
# ..:;;. ' .;;:..        Usage // !coin [guess]
#    .  '''  .     Permissions // Public.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub coin {
	my ($self,$client,$msg) = @_;

	# Flip a coin.
	my $coin = int(rand(2)) + 1;

	# 1 = heads, 2 = tails.
	if ($coin == 1) {
		# If they guessed heads.
		if (length $msg > 0 && $msg =~ /^heads$/i) {
			# Correct!
			return "I flipped a coin and got heads. You win!";
		}
		else {
			return "I flipped a coin and got heads.";
		}
	}
	else {
		# If they guessed tails.
		if (length $msg > 0 && $msg =~ /^tails$/i) {
			# Correct!
			return "I flipped a coin and got tails. You win!";
		}
		else {
			return "I flipped a coin and got tails.";
		}
	}
}
{
	Category    => 'Fun Stuff',
	Description => 'Flip a coin.',
	Usage       => '!coin [heads|tails]',
	Listener    => 'All',
};