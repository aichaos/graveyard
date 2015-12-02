# A contact is removing us.

sub msn_remove {
	my ($notify,$client) = @_;

	my $sn = &normalize ($notify->{Msn}->{Handle});

	print &timestamp . "\n"
		. "AidenMSN: $client has removed $sn from their contact list.\n\n";
}
1;