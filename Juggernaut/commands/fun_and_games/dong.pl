#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !dong
#    .::   ::.     Description // Keep a blonde occupied.
# ..:;;. ' .;;:..        Usage // !dong
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub dong {
	# Get variables from the shift.
	my ($self,$client,$msg,$listener) = @_;

	# Refer them to the other command.
	return "The !dong command has been changed to !ding. Type !ding to use this command.";
}

{
	Hidden => 1,
	Category => 'Fun & Games',
	Description => 'Keeps a Blonde Busy',
	Usage => '!dong',
	Listener => 'All',
};