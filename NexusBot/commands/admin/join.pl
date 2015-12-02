# COMMAND NAME:
#	JOIN
# DESCRIPTION:
#	Join an MSN socket.
# COMPATIBILITY:
#	MSN ONLY

sub join {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we're on MSN.
	if ($listener eq "MSN") {
		if ($msg) {
			# Join the socket.
			return "Could not join socket." unless exists $self->GetMaster->{Socks}->{$msg};

			$self->GetMaster->{Socks}->{$msg}->invite ($client);
			$reply = "Joining socket $msg...";
			$self->GetMaster->{Socks}->{$msg}->sendmsg ("$client has joined us...",
				Font => "Courier New", Color => "990000");
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
1;