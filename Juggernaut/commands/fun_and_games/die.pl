#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !die
#    .::   ::.     Description // Roll an X-sided die.
# ..:;;. ' .;;:..        Usage // !die <number>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub die {
	my ($self,$client,$msg,$listener) = @_;

	# Impossibilities.
	return "You can only use numbers when getting a random number, smarty!" if $msg =~ /[^0-9]/;
	return "I think you are abusing this command. Calculating a random number that's over "
		. "10 digits long is just crazy. Keep your calculations to 10 or less digits."
		if length $msg > 10;
	return "You can't calculate a random number from zero." if $msg == 0;

	# Make sure they have a number to roll for.
	if (length $msg > 0) {
		my $result = int(rand($msg)) + 1;

		$reply = "I have rolled a $msg sided die and returned: $result.";
	}
	else {
		$reply = "The die command requires a number:\n\n!die 6";
	}

	return $reply;
}

{
	Category => 'Fun & Games',
	Description => 'Roll an X sided die',
	Usage => '!die <# of sides>',
	Listener => 'All',
};