# Convo was closed.

sub msn_close {
	my ($self) = @_;

	my $sn = &normalize ($notify->{Msn}->{Handle});

	my $sock = $self->getID;

	print &timestamp . "\n"
		. "AidenMSN: Now closing socket #$sock.\n\n";
}
1;