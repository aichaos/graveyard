#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !formalize
#    .::   ::.     Description // Make a string formal.
# ..:;;. ' .;;:..        Usage // !formalize <string>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub formalize {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we have a string to make uppercase.
	if ($msg) {
		$reply = "Result: " . formal ($msg);
	}
	else {
		$reply = "This command is used to formalize a string.\n\n"
			. "!formalize john doe jr.";
	}

	return $reply;
}

{
	Category => 'Bot Utilities',
	Description => 'Formalize a String',
	Usage => '!formalize <string>',
	Listener => 'All',
};