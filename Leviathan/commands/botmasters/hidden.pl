#      .   .               <Leviathan>
#     .:...::     Command Name // !hidden
#    .::   ::.     Description // Displays all "hidden" commands.
# ..:;;. ' .;;:..        Usage // !hidden
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2005 AiChaos Inc.

sub hidden {
	my ($self,$client,$msg) = @_;

	# This command is Master Only.
	return "This command is Master Only!" unless &isMaster($client);

	# Find all hidden commands.
	my @hidden = ();
	foreach my $cmd (keys %{$chaos->{system}->{commands}}) {
		if (exists $chaos->{system}->{commands}->{$cmd}->{Hidden}) {
			if (defined $chaos->{system}->{commands}->{$cmd}->{Hidden}) {
				push (@hidden, $cmd);
			}
		}
	}

	if (@hidden) {
		return "Hidden Commands:\n\n"
			. join ("\n", @hidden);
	}
	else {
		return "No commands are marked as \"Hidden.\"";
	}
}
{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Display all "hidden" commands.',
	Usage => '!hidden',
	Listener => 'All',
};