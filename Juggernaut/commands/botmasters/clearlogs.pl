#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !clearlogs
#    .::   ::.     Description // Clear the collective conversation logs.
# ..:;;. ' .;;:..        Usage // !clearlogs
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub clearlogs {
	# Get variables.
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we're the master.
	if (isMaster($client,$listener)) {
		# Delete the logs.
		opendir (LOGS, "./logs");
		foreach my $file (sort(grep(!/^\./, readdir(LOGS)))) {
			# Only delete text documents.
			if ($file =~ /\.txt/i) {
				unlink ("./logs/$file");
			}
		}
		closedir (LOGS);

		# Return the reply.
		return "Conversation logs deleted!";
	}
	else {
		return "This command may only be used by my master.";
	}
}

{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Clear Collective Conversation Logs',
	Usage => '!clearlogs',
	Listener => 'All',
};