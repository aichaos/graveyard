#      .   .               <Leviathan>
#     .:...::     Command Name // !clearlogs
#    .::   ::.     Description // Deletes the collective conversation logs.
# ..:;;. ' .;;:..        Usage // !clearlogs
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2005 AiChaos Inc.

sub clearlogs {
	my ($self,$client,$msg) = @_;

	# This command is Master Only.
	return "This command is Master Only!" unless &isMaster($client);

	# Find the log file.
	my $file = '';
	if (-e "./logs/chat/convo.html") {
		$file = "convo.html";
	}
	elsif (-e "./logs/chat/convo.txt") {
		$file = "convo.txt";
	}

	if (length $file == 0) {
		return "The log file does not exist yet.";
	}

	# Add a queue to unlink the file.
	&queue ('_system', 1, "unlink (\"./logs/chat/$file\");");
	return "Conversation logs cleared!";
}
{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Clear the collective conversation logs.',
	Usage => '!clearlogs',
	Listener => 'All',
};