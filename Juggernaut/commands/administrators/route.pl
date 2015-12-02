#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !route
#    .::   ::.     Description // Send message to another user (through socket or AIM IM)
# ..:;;. ' .;;:..        Usage // !route <socket|screenname>-><message>
#    .  '''  .     Permissions // Admin Only
#     :;,:,;:         Listener // AIM, MSN
#     :     :        Copyright // 2004 Chaos AI Technology

sub route {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure they're an admin.
	if (isAdmin($client,$listener) == 0) {
		return "This command is admin-only!";
	}

	my $sock;
	my $name = $chaos->{_users}->{$client}->{name};

	# Make sure we're on MSN or AIM.
	if ($listener eq "MSN") {
		($sock,$msg) = split(/\-\>/, $msg, 2);
		if (length $sock > 0) {
			# Get the handle.
			my $sn = $self->{Msn}->{Handle};
			$sn = lc($sn); $sn =~ s/ //g;

			# Make sure the socket exists.
			my $socks = $chaos->{$sn}->{client}->getConvoList();

			my $found = 0;
			foreach my $id (%{$socks}) {
				if ($sock eq $id) {
					$found = 1;
				}
			}

			# If it exists...
			if ($found) {
				my $convo = $chaos->{$sn}->{client}->getConvo ($sock);
				$convo->sendmsg ("Message from $name: $msg",
					Font => "Courier New",
					Color => "0000FF",
				);

				return "I have sent the message to socket $sock.";
			}
			else {
				return "That socket does not exist!";
			}
		}
		else {
			$reply = "You must provide a socket number and message.\n\n"
				. "!route [ID]->[message]";
		}
	}
	elsif ($listener eq "AIM") {
		($sock,$msg) = split(/\-\>/, $msg, 2);
		if ($sock) {
			# Send the message.
			my $sn = $self->screenname();
			my $font = get_font ($screenname, "AIM");
			$self->send_im ($sock,$font . "Message from $name: $msg");

			$reply = "I have sent the message to $sock.";
		}
		else {
			$reply = "You must provide a screenname!\n\n"
				. "!route screenname->message";
		}
	}
	else {
		$reply = "This command is for MSN Messenger and AIM only.";
	}

	return $reply;
}

{
	Restrict => 'Administrator',
	Category => 'Administrator Commands',
	Description => 'Send a Message Through Me',
	Usage => '!route <socket|screenname> -> <msg>',
	Listener => 'AIM/MSN',
};