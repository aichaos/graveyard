# COMMAND NAME:
#	LCSTR
# DESCRIPTION:
#	Make a string lowercase.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub lcstr {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we have a string to make lowercase.
	if ($msg) {
		$reply = "Result: " . lc($msg);
	}
	else {
		$reply = "This command is used to lowercase a string.\n\n"
			. "!lcstr HeLlO wOrLd!";
	}

	return $reply;
}
1;