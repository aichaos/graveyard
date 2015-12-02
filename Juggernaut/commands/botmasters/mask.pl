#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !mask
#    .::   ::.     Description // Hide your conversation logs.
# ..:;;. ' .;;:..        Usage // !mask
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub mask {
	my ($self,$client,$msg,$listener) = @_;

	# This command can only be used by the Master.
	if (isMaster ($client,$listener)) {
		# Toggle the mask.
		if ($chaos->{_users}->{$client}->{_mask} == 1) {
			$chaos->{_users}->{$client}->{_mask} = 0;
			return "Mask Mode: OFF";
		}
		else {
			$chaos->{_users}->{$client}->{_mask} = 1;
			return "Mask Mode: ON";
		}
	}
	else {
		return "This command may only be used by the botmaster.";
	}
}

{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Turns Off Personal Logging/Printing',
	Usage => '!mask',
	Listener => 'All',
};