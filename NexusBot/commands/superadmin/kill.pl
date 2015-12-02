# COMMAND NAME:
#	KILL
# DESCRIPTION:
#	Kill an MSN socket.
# COMPATIBILITY:
#	MSN ONLY

sub kill {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we're on MSN.
	if ($listener eq "MSN") {
		if ($msg) {
			# Kill the socket.
			$self->GetMaster->{Socks}->{$msg}->sendraw ("OUT\r\n");

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
1;