#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !join
#    .::   ::.     Description // Join an MSN conversation (MSN chats must be enabled)
# ..:;;. ' .;;:..        Usage // !join <socket id>
#    .  '''  .     Permissions // Admin Only
#     :;,:,;:         Listener // MSN
#     :     :        Copyright // 2004 Chaos AI Technology

sub join {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure they're an admin.
	if (isAdmin($client,$listener) == 0) {
		return "This command is admin-only!";
	}

	# Make sure we're on MSN.
	if ($listener eq "MSN") {
		if (length $msg > 0) {
			# Get the handle.
			my $sn = $self->{Msn}->{Handle};
			$sn = lc($sn); $sn =~ s/ //g;

			# Make sure the socket exists.
			my $socks = $chaos->{$sn}->{client}->getConvoList();

			my $found = 0;
			foreach my $id (%{$socks}) {
				if ($msg eq $id) {
					$found = 1;
				}
			}

			# If found...
			if ($found) {
				my $convo = $chaos->{$sn}->{client}->getConvo ($msg);
				$convo->invite ($client);
				sleep (1);
				$convo->sendmsg ("$client has joined us...",
					Font  => 'Courier New',
					Color => '990000',
					Style => 'B',
				);

				return "Joining socket #$msg...";
			}
			else {
				return "That socket does not exist!";
			}
		}
		else {
			$reply = "You must provide a socket number.\n\n"
				. "!join [ID]";
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
	Description => 'Join Any Open Socket',
	Usage => '!join <socket>',
	Listener => 'MSN',
};