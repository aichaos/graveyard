# Somebody wants to chat with us.

sub msn_ring {
	my ($self,$client,$name) = @_;

	my $sn = &normalize ($notify->{Msn}->{Handle});

	my $sock = $self->getID;

	$client = join ('-', 'MSN', &normalize($client));

	# If blocked, deny the ring.
	if (&isBlocked($client)) {
		return 0;
	}

	return 1;
}
1;