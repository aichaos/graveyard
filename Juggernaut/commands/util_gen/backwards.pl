#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !backwards
#    .::   ::.     Description // Reverse a message!
# ..:;;. ' .;;:..        Usage // !backwards <message>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub backwards {
	my ($self,$client,$msg,$listener) = @_;

	# If there's a message to reverse...
	if (length $msg > 0) {
		my @chars = split(//, $msg);
		my @new = reverse (@chars);
		return join ("", @new);
	}
	else {
		return "Give me a message to reverse:\n\n"
			. "!reverse The quick brown fox jumps over the lazy dog.";
	}
}

{
	Category => 'General Utilities',
	Description => 'Reverse Your Text',
	Usage => '!backwards <string>',
	Listener => 'All',
};