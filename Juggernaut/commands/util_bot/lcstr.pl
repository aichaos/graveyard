#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !lcstr
#    .::   ::.     Description // Make a string all lower-case.
# ..:;;. ' .;;:..        Usage // !lcstr <string>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub lcstr {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we have a string to make lowercase.
	if ($msg) {
		$reply = "Result: " . lc($msg);
	}
	else {
		$reply = "This command is used to lowercase a string.\n\n"
			. "!lcstr HeLlO wOrLd!";
	}

	return $reply;
}

{
	Category => 'Bot Utilities',
	Description => 'Lowercase a String',
	Usage => '!lcstr <string>',
	Listener => 'All',
};