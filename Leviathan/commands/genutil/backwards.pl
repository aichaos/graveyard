#      .   .               <Leviathan>
#     .:...::     Command Name // !backwards
#    .::   ::.     Description // Reverse your text.
# ..:;;. ' .;;:..        Usage // !backwards <text>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub backwards {
	my ($self,$client,$msg) = @_;

	return "Give me a message to reverse when calling this command." if length $msg == 0;

	my @chars = split(//, $msg);
	my @new = reverse(@chars);
	return CORE::join ("", @new);
}
{
	Category => 'Utilities',
	Description => 'Reverse your text.',
	Usage => '!backwards <text>',
	Listener => 'All',
};