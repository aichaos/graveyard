#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !ding
#    .::   ::.     Description // Keep a blonde occupied.
# ..:;;. ' .;;:..        Usage // !ding
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub ding {
	# Get variables from the shift.
	my ($self,$client,$msg,$listener) = @_;

	# Refer them to the other command.
	return "The !ding command has been changed to !dong. Type !dong to use this command.";
}

{
	Category => 'Fun & Games',
	Description => 'Keeps a Blonde Busy',
	Usage => '!ding',
	Listener => 'All',
};