# COMMAND NAME:
#	TAG
# DESCRIPTION:
#	IM Tag. Designed for AIM. MSN's tag is "!mstag"
# COMPATIBILITY:
#	AIM

sub tag {
	# Get variables from the shift.
	my ($client,$msg,$aim) = @_;

	# Make sure they're not an MSN user.
	if ($client !~ /\@/i) {
		# Cut the command off.
		$msg =~ s/\!tag //ig;

		if ($msg ne "") {
			if (warners($aim,$msg)) {
				$reply = "I won't tag $msg because he's on my warners list.";
			}
			else {
				# Tag the user.
				my $tag_msg = ("<body bgcolor=white><font face=Verdana size=2 color=black>"
					. "You have been <b>tagged</b>! We're playing IM Tag. To tag somebody, "
					. "just type <b>!tag screenname</b></font></body>");
				sleep(dosleep(1,3));
				$aim->send_im ($msg,$tag_msg);

				$reply = "I have tagged $msg.";
			}
		}
		else {
			$reply = "To tag somebody, type <b>!tag screenname</b>";
		}
	}
	else {
		$reply = ("Sorry, this is the AOL Instant Messenger command. The MSN "
			. "command is !mstag.");
	}

	return $reply;
}
1;