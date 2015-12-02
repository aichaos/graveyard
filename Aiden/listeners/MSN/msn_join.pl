# Somebody joined us.

sub msn_join {
	my ($self,$client,$name) = @_;

	my $sn = &normalize ($notify->{Msn}->{Handle});

	my $sock = $self->getID;

	my $buds = $self->getMembers;
	my @buddies = scalar keys %$buds;

	if (scalar(@buddies) > 1) {
		print &timestamp . "\n"
			. "AidenMSN: $client has joined socket #$sock\n"
			. "AidenMSN: Leaving #$sock -- too many members.\n\n";

		eval ('$self->leave();');
	}
}
1;