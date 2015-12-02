# Disconnected.

sub msn_disconnect {
	my $msn = shift;
	my $reason = shift || 'unknown';

	my $sn = &normalize ($msn->{Handle});

	print &timestamp . "\n"
		. "AidenMSN: $sn disconnected (Reason: $reason)\n\n";
}
1;