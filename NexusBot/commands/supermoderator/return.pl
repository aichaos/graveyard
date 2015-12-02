# COMMAND NAME:
#	RETURN
# DESCRIPTION:
#	Returns the bot from away state.
# COMPATIBILITY:
#	AIM,MSN

sub return {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we're on the right messengers...
	if ($listener eq "AIM" || $listener eq "MSN") {
		# K, we're good.

		# Either messenger, we're going to return.
		if ($listener eq "AIM") {
			# Put up the away message.
			$self->set_away ("");

			$reply = "I have returned.";
		}
		# If on MSN, set an away status.
		if ($listener eq "MSN") {
			# Set a "BRB" status.
			$self->set_status ('NLN');

			$reply = "I have returned.";
		}
	}
	else {
		$reply = ("This command can only be used on AIM or MSN. For "
			. "more information type !help return");
	}

	return $reply;
}
1;