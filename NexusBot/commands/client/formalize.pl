# COMMAND NAME:
#	FORMALIZE
# DESCRIPTION:
#	Make a string formal.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub formalize {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we have a string to make uppercase.
	if ($msg) {
		$reply = "Result: " . formal ($msg);
	}
	else {
		$reply = "This command is used to formalize a string.\n\n"
			. "!formalize john doe jr.";
	}

	return $reply;
}
1;