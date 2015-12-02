#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !idiot
#    .::   ::.     Description // Keep an idiot occupied!
# ..:;;. ' .;;:..        Usage // !idiot
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub idiot {
	# Get variables from the shift.
	my ($self,$client,$msg,$listener) = @_;

	# See what number they're on.
	if ($chaos->{_users}->{$client}->{_idiot}->{step} == 1) {
		$chaos->{_users}->{$client}->{_idiot}->{step} = 2;
		return "Are you absolutely positive?";
	}
	elsif ($chaos->{_users}->{$client}->{_idiot}->{step} == 2) {
		$chaos->{_users}->{$client}->{_idiot}->{step} = 3;
		return "I'm about to tell you. Do you really want to know?";
	}
	elsif ($chaos->{_users}->{$client}->{_idiot}->{step} == 3) {
		$chaos->{_users}->{$client}->{_idiot}->{step} = 4;
		return "If you really want to know, say so now.";
	}
	elsif ($chaos->{_users}->{$client}->{_idiot}->{step} == 4) {
		$chaos->{_users}->{$client}->{_idiot}->{step} = 5;
		return "Alright, give the word one more time and I'll reveal the secret.";
	}
	elsif ($chaos->{_users}->{$client}->{_idiot}->{step} == 5) {
		# Delete the variables.
		delete $chaos->{_users}->{$client}->{callback};
		delete $chaos->{_users}->{$client}->{_idiot}->{step};

		return "Congratulations, you now know the secret to keeping an idiot occupied.";
	}
	else {
		# Set the callback.
		$chaos->{_users}->{$client}->{callback} = "idiot";

		# Set the step to #1.
		$chaos->{_users}->{$client}->{_idiot}->{step} = 1;

		# Return the reply.
		return "Are you sure you want to learn how to keep an idiot occupied?";
	}
}

{
	Category => 'Fun & Games',
	Description => 'Keep an Idiot Occupied',
	Usage => '!idiot',
	Listener => 'All',
};