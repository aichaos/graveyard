# COMMAND NAME:
#	AWAY
# DESCRIPTION:
#	Sets an away message or status.
# COMPATIBILITY:
#	AIM,MSN

sub away {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we're on the right messengers...
	if ($listener eq "AIM" || $listener eq "MSN") {
		# K, we're good.

		# If on AIM, set an away message.
		if ($listener eq "AIM") {
			if ($msg eq "") {
				$msg = "I am away from my computer right now.";
			}

			# Get the AIM font.
			my $font = get_aim_font();

			# Append the font to the message.
			$msg = ($font . $msg);

			# Transform custom HTML.
			$msg =~ s/\&lt\;/</ig;
			$msg =~ s/\&gt\;/>/ig;
			$msg =~ s/\&quot\;/"/ig;
			$msg =~ s/\&apos\;/'/ig;
			$msg =~ s/\&amp\;/\&/ig;

			# Put up the away message.
			$self->set_away ($msg);

			$reply = "I have set the away message.";
		}
		# If on MSN, set an away status.
		if ($listener eq "MSN") {
			# Set a "BRB" status.
			$self->set_status ('BRB');

			$reply = "I am away now.";
		}
	}
	else {
		$reply = ("This command can only be used on AIM or MSN. For "
			. "more information type !help away");
	}

	return $reply;
}
1;