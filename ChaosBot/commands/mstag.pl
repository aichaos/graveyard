# COMMAND NAME:
#	MSTAG
# DESCRIPTION:
#	IM Tag. Designed for MSN. AIM's tag is "!mstag"
# COMPATIBILITY:
#	MSN

sub mstag {
	# Get variables from the shift.
	my ($client,$msg,$msn) = @_;

	# Make sure they're not an MSN user.
	if ($client =~ /\@/i) {
		# Cut the command off.
		$msg =~ s/\!mstag //ig;

		if ($msg ne "") {
			# Tag the user.
			my $tag_msg = ("You have been TAGGED! We're playing IM Tag. To tag somebody, "
				. "just type:\n\n!tag screenname");
			$msn->call ($msg,$tag_msg);

			$reply = "I have tagged $msg.";
		}
		else {
			$reply = "To tag somebody, type !tag screenname";
		}
	}
	else {
		$reply = ("Sorry, this is the MSN Messenger command. The AIM "
			. "command is !tag.");
	}

	return $reply;
}
1;