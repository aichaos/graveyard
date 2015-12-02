#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !lock
#    .::   ::.     Description // Lock all commands (all become admin only).
# ..:;;. ' .;;:..        Usage // !lock
#    .  '''  .     Permissions // Admin Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub lock {
	# Get variables.
	my ($self,$client,$msg,$listener) = @_;

	# Make sure they're an Admin.
	if (isAdmin($client,$listener)) {
		# Lock the commands.
		my $sn;
		$sn = $self->{Msn}->{Handle} if $listener eq "MSN";
		$sn = $self->screenname() if $listener eq "AIM";
		$sn = lc($sn);
		$sn =~ s/ //g;

		$chaos->{$sn}->{lock} = 1;

		return "Commands have been locked.";
	}
	else {
		return "This command is Admin Only.";
	}
}

{
	Restrict => 'Administrator',
	Category => 'Administrator Commands',
	Description => 'Lock Commands for Lower Users',
	Usage => '!lock',
	Listener => 'All',
};