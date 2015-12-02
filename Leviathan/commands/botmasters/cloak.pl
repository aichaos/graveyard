#      .   .               <Leviathan>
#     .:...::     Command Name // !cloak
#    .::   ::.     Description // Don't Log Your Conversations.
# ..:;;. ' .;;:..        Usage // !cloak
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2005 AiChaos Inc.

sub cloak {
	my ($self,$client,$msg) = @_;

	# This command is Master Only.
	return "This command is Master Only!" unless &isMaster($client);

	# If not existing, set to 0.
	if (!exists $chaos->{clients}->{$client}->{cloak}) {
		$chaos->{clients}->{$client}->{cloak} = 0;
	}

	# Toggle switch.
	if ($chaos->{clients}->{$client}->{cloak} == 0) {
		$chaos->{clients}->{$client}->{cloak} = 1;
		return "Cloaking mode Activated.";
	}
	else {
		$chaos->{clients}->{$client}->{cloak} = 0;
		return "Cloaking mode DeActivated.";
	}
}
{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Don\'t log your conversations.',
	Usage => '!cloak',
	Listener => 'All',
};