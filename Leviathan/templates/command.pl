#      .   .               <Leviathan>
#     .:...::     Command Name // !command
#    .::   ::.     Description // Command Template
# ..:;;. ' .;;:..        Usage // !command
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2004 Command Author's Name

sub command {
	my ($self,$client,$msg) = @_;

	# Return a reply.
	return "This is a command template.";
}
{
	Category => 'General',
	Description => 'Command Template.',
	Usage => '!command',
	Listener => 'All',
};
