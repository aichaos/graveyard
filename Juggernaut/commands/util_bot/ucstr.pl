#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !ucstr
#    .::   ::.     Description // Make a string uppercase.
# ..:;;. ' .;;:..        Usage // !ucstr <string>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub ucstr {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we have a string to make uppercase.
	if ($msg) {
		$reply = "Result: " . uc($msg);
	}
	else {
		$reply = "This command is used to uppercase a string.\n\n"
			. "!ucstr HeLlO wOrLd!";
	}

	return $reply;
}

{
	Category => 'Bot Utilities',
	Description => 'Uppercase a String',
	Usage => '!ucstr <string>',
	Listener => 'All',
};