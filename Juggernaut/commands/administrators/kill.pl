#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !kill
#    .::   ::.     Description // Kill an MSN conversation.
# ..:;;. ' .;;:..        Usage // !kill <socket id>
#    .  '''  .     Permissions // Admin Only
#     :;,:,;:         Listener // MSN
#     :     :        Copyright // 2004 Chaos AI Technology

sub kill {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure they're an admin.
	if (isAdmin($client,$listener) == 0) {
		return "This command is admin-only!";
	}

	# Make sure we're on MSN.
	if ($listener eq "MSN") {
		# Get the handle.
		my $sn = $self->{Msn}->{Handle};
		$sn = lc($sn);
		$sn =~ s/ //g;

		if (length $msg > 0) {
			return "This IS that socket!" if $msg eq $self->getID;
			my $convo = $chaos->{$sn}->{client}->getConvo ($msg);
			return "Could not kill socket." unless defined $convo;

			# Kill the socket.
			$convo->leave() if (defined $convo);

			$reply = "I have killed socket $msg.";
		}
		else {
			$reply = "You must provide a socket number.\n\n"
				. "!kill [ID]";
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
	Description => 'Kill a Socket',
	Usage => '!kill <socket>',
	Listener => 'MSN',
};