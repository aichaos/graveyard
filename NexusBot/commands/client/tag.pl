# COMMAND NAME:
#	TAG
# DESCRIPTION:
#	Play a game of IM Tag!
# COMPATIBILITY:
#	AIM,MSN

sub tag {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we're on MSN or AIM..
	if ($listener eq "MSN" || $listener eq "AIM") {
		# If we have somebody TO tag, let's do it.
		if ($msg) {
			my $tagmsg;
			if ($listener eq "AIM") {
				$tagmsg = ("<body bgcolor=\"white\">"
					. "<font face=\"Verdana\" size=\"2\" color=\"black\">"
					. "You have been <b>Tagged</b> by $client! We're playing "
					. "IM Tag. To tag somebody, type !tag screenname</font></body>");
				sleep(2);
				$self->send_im ($msg, $tagmsg);
			}
			elsif ($listener eq "MSN") {
				$tagmsg = ("You have been TAGGED by (M) $client! We're playing IM Tag. "
					. "To tag somebody, type !tag email");
				$self->call ($msg, $tagmsg, Font => "Verdana",Color => "FF0000");
			}

			$reply = "I have attempted to tag $msg.";
		}
	}
	else {
		$reply = "Sorry, this command is for AIM and MSN only.";
	}

	return $reply;
}
1;