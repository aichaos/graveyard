# COMMAND NAME:
#	UCSTR
# DESCRIPTION:
#	Make a string uppercase.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub ucstr {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we have a string to make uppercase.
	if ($msg) {
		$reply = "Result: " . uc($msg);
	}
	else {
		$reply = "This command is used to uppercase a string.\n\n"
			. "!ucstr HeLlO wOrLd!";
	}

	return $reply;
}
1;