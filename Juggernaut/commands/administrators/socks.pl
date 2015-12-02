#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !socks
#    .::   ::.     Description // List all open MSN conversations.
# ..:;;. ' .;;:..        Usage // !socks
#    .  '''  .     Permissions // Admin Only
#     :;,:,;:         Listener // MSN
#     :     :        Copyright // 2004 Chaos AI Technology

sub socks {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure they're an admin.
	if (isAdmin($client,$listener) == 0) {
		return "This command is admin-only!";
	}

	# Get the handle.
	my $sn = $self->{Msn}->{Handle};
	$sn = lc($sn);
	$sn =~ s/ //g;

	my $msn = $chaos->{$sn}->{client};

	# Make sure we're on MSN.
	if ($listener eq "MSN") {
		# List the sockets.
		$reply = "Open Sockets:\n\n";

		my $socks = $msn->getConvoList();

		foreach my $id (keys %{$socks}) {
			my $convo = $msn->getConvo ($id);
			my $buddies = $convo->getMembers ();
			my $buds = join (", ", keys %{$buddies});

			$reply .= "$id=$buds\n\n";
		}
	}
	else {
		$reply = "This command is for MSN Messenger only.";
	}

	return $reply;
}

{
	Restrict => 'Administrator',
	Category => 'Administrator Commands',
	Description => 'Lists All Open Sockets',
	Usage => '!socks',
	Listener => 'MSN',
};