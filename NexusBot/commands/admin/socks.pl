# COMMAND NAME:
#	SOCKS
# DESCRIPTION:
#	List all open MSN sockets.
# COMPATIBILITY:
#	MSN ONLY

sub socks {
	my ($msn,$client,$msg,$listener) = @_;

	#my $msn = $self;
	my $id;

	print $msn->GetMaster->{Handle} . "\n";

	# Make sure we're on MSN.
	if ($listener eq "MSN") {
		# List the sockets.
		$reply = "Open Sockets:\n\n";
		foreach $id (keys %{$msn->GetMaster->{Socks}}) {
			next unless defined $msn->GetMaster->{Socks}->{$id} && $msn->GetMaster->{Socks}->{$id}->{Type} eq 'SB';
			$reply .= "$id=" . join (", ", keys %{$msn->GetMaster->{Socks}->{$id}->{Buddies}}) . "\n";
		}
	}
	else {
		$reply = "This command is for MSN Messenger only.";
	}

	return $reply;
}
1;