# COMMAND NAME:
#	CHAT
# DESCRIPTION:
#	Join the chatroom!
# COMPATIBILITY:
#	MSN

sub chat {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we're on MSN.
	if ($listener eq "MSN") {
		# See if the chatroom doesn't exist.
		if (!exists $chaos->{msn}->{chat} or !exists $self->GetMaster->{Socks}->{$chaos->{msn}->{chat}->{fn}}) {
			print "ChaosMSN: The chatroom has been created.\n";
			$chaos->{msn}->{chat} = $self;
			$self->sendmsg ("This is now the chatroom.",Font => "Courier New",Color => "FF0000");
		}
		elsif ($self eq $chaos->{msn}->{chat}) {
			print "ChaosMSN: They're already in the chat!\n";
			$self->sendmsg ("You are already in the chat.",Font => "Courier New",Color => "FF0000");
		}
		else {
			print "ChaosMSN: $client is joining the chat...\n";
			$reply = "Joining the chatroom...";
			$chaos->{msn}->{chat}->invite ($client);
			sleep(2);
			$chaos->{msn}->{chat}->sendmsg ("$client has joined the chatroom.",
				Font => "Courier New", Color => "990000");
		}
	}
	else {
		$reply = "This command is for MSN only.";
	}

	return $reply;
}
1;