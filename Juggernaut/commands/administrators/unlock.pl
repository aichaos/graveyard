#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !unlock
#    .::   ::.     Description // Unlock all locked commands.
# ..:;;. ' .;;:..        Usage // !unlock
#    .  '''  .     Permissions // Admin Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub unlock {
	# Get variables.
	my ($self,$client,$msg,$listener) = @_;

	# Make sure they're an Admin.
	if (isAdmin($client,$listener)) {
		# UnLock the commands.
		my $sn;
		$sn = $self->{Msn}->{Handle} if $listener eq "MSN";
		$sn = $self->screenname() if $listener eq "AIM";
		$sn = lc($sn);
		$sn =~ s/ //g;

		$chaos->{$sn}->{lock} = 0;

		return "Commands have been unlocked.";
	}
	else {
		return "This command is Admin Only.";
	}
}

{
	Restrict => 'Administrator',
	Category => 'Administrator Commands',
	Description => 'Unlock Commands for Lower Users',
	Usage => '!unlock',
	Listener => 'All',
};