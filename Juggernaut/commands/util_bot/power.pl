#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !power
#    .::   ::.     Description // Get power information about self or other user.
# ..:;;. ' .;;:..        Usage // !power [listener-username]
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub power {
	my ($self,$client,$msg,$listener) = @_;

	# Help them if they thought POWER was plural. :-P
	$msg = "" if $msg eq "s";

	# If they're not asking about anybody...
	if (length $msg == 0) {
		$msg = $listener . '-' . $client;
	}

	# If they're wondering about somebody...
	my $loop = 0;
	power_checker:
	if (length $msg > 0) {
		my ($lis,$who) = split(/\-/, $msg, 2);

		# Array of permissions.
		my @powers;

		push (@powers, "-Botmaster") if isMaster($who,$lis);
		push (@powers, "-Administrator") if isAdmin($who,$lis);
		push (@powers, "-Moderator") if isMod($who,$lis);
		push (@powers, "-Client");

		my $total_power = join ("\n", @powers);

		# Return the information.
		return "Power Info\n\n"
			. ":: $who ($lis)\n"
			. $total_power;
	}
	else {
		return "Unknown Error";
	}
}

{
	Category => 'Bot Utilities',
	Description => 'Check a User\'s Powers',
	Usage => '!power [listener-username]',
	Listener => 'All',
};