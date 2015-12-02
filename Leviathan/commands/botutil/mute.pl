#      .   .               <Leviathan>
#     .:...::     Command Name // !mute
#    .::   ::.     Description // Toggles the bot stop replying to you.
# ..:;;. ' .;;:..        Usage // !mute
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub mute {
	my ($self,$client,$msg) = @_;

	if (!exists $chaos->{clients}->{$client}->{mute}) {
		$chaos->{clients}->{$client}->{mute} = 0;
	}

	# If NOT muted...
	if ($chaos->{clients}->{$client}->{mute} == 0) {
		# Mute.
		&queue ('_system', 1, "\$chaos->{clients}->{'$client'}->{mute} = 1;");

		return "You are now muted; type !mute again when you want to talk!";
	}
	else {
		# Unmute.
		$chaos->{clients}->{$client}->{mute} = 0;

		return "Thanks. :-) I'll talk again.";
	}
}

{
	Category => 'Bot Utilities',
	Description => 'Toggles me to stop replying to you.',
	Usage => '!mute',
	Listener => 'All',
};