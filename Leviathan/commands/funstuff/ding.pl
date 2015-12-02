#      .   .               <Leviathan>
#     .:...::     Command Name // !ding
#    .::   ::.     Description // Keep a blonde occupied.
# ..:;;. ' .;;:..        Usage // !ding
#    .  '''  .     Permissions // Public.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub ding {
	my ($self,$client,$msg) = @_;

	return "This command has been renamed to !dong - type !dong to use this command.";
}
{
	Category    => 'Fun Stuff',
	Description => 'Keep a blonde occupied.',
	Usage       => '!ding',
	Listener    => 'All',
};