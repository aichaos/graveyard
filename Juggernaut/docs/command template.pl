#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !command
#    .::   ::.     Description // Command Template
# ..:;;. ' .;;:..        Usage // !command [arguments]
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub command {
	my ($self,$client,$msg,$listener) = @_;

	return "command reply";
}

{
	Category => 'General',
	Description => 'Command Template',
	Usage => '!command [arguments]',
	Listener => 'All',
};