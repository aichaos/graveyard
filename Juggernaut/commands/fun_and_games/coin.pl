#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !coin
#    .::   ::.     Description // Flip a coin!
# ..:;;. ' .;;:..        Usage // !coin [guess?]
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub coin {
	my ($self,$client,$msg,$listener) = @_;

	# Flip a coin!
	my $side = int(rand(2)) + 1;

	my $name;
	$name = "heads" if $side == 1;
	$name = "tails" if $side == 2;

	# If they were trying to guess one...
	if (length $msg > 0) {
		if ($msg eq "heads" || $msg eq "tails") {
			if ($msg eq "heads" && $name eq "heads") {
				return "Good call! I flipped the coin and got heads!";
			}
			elsif ($msg eq "tails" && $name eq "tails") {
				return "Good call! I flipped the coin and got tails!";
			}
			else {
				return "Nope! I flipped and got $name! :-P";
			}
		}
		else {
			return "If you want to guess, type only 'heads' or 'tails'.\n\n"
				. "By the way... I got $name.";
		}
	}
	else {
		return "Flipped a coin and got: $name.";
	}
}

{
	Category => 'Fun & Games',
	Description => 'Flip a Coin',
	Usage => '!coin [call]',
	Listener => 'All',
};