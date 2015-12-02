#      .   .               <Leviathan>
#     .:...::     Command Name // !dong
#    .::   ::.     Description // Keep a blonde occupied.
# ..:;;. ' .;;:..        Usage // !dong
#    .  '''  .     Permissions // Public.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub dong {
	my ($self,$client,$msg) = @_;

	return "This command has been renamed to !ding - type !ding to use this command.";
}
{
	Hidden      => 1,
	Category    => 'Fun Stuff',
	Description => 'Keep a blonde occupied.',
	Usage       => '!dong',
	Listener    => 'All',
};