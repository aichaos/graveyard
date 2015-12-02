# blockUser.pl - block a user.

sub blockUser {
	my $client = shift;
	my $multiply = shift || 1;

	# Get this user's records.
	my $blocks = $aiden->{clients}->{$client}->{blocks};

	# Add one to his number of times blocked.
	$blocks++;

	# Save the new value.
	&userSend ($client,'blocks',$blocks);

	# Calculate blocked time.
	my $mins = $blocks * $blocks * 15 * $multiply;
	my $time = $mins * 60;

	my $expires = time() + $time;

	# Block him.
	&userSend ($client,'blocked',1);
	&userSend ($client,'expires',$expires);

	return $mins;
}
1;