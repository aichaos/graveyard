#      .   .               <Leviathan>
#     .:...::     Command Name // !updates
#    .::   ::.     Description // Get current updates.
# ..:;;. ' .;;:..        Usage // !updates [new updates]
#    .  '''  .     Permissions // Public [Master Only]
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2005 AiChaos Inc.

sub updates {
	my ($self,$client,$msg) = @_;

	# If setting updates...
	if (length $msg > 0) {
		# Must be master.
		if (&isMaster($client)) {
			# Set the updates.
			open (UPDATES, ">./data/updates.txt");
			print UPDATES $msg;
			close (UPDATES);

			return "The updates have been saved.";
		}
		else {
			return "Only botmasters can set updates!";
		}
	}
	else {
		# Return the updates.
		open (OPEN, "./data/updates.txt") or return "There are no new updates.";
		my @updates = <OPEN>;
		close (OPEN);
		chomp @updates;

		return ":: Current Updates ::\n\n"
			. CORE::join ("\n", @updates);
	}
}

{
	Category => 'General',
	Description => 'See the latest bot updates.',
	Usage => '!updates [botmasters: set new update]',
	Listener => 'All',
};