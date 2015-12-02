# COMMAND NAME:
#	WARN
# DESCRIPTION:
#	Adds a user to the warners list.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub warn {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we have somebody TO add.
	if ($msg) {
		# Add them to the blocked list.
		open (LIST, ">>./data/warners.txt");
		print LIST "$msg\n";
		close (LIST);

		$reply = "I have added $msg to the warners list.";
	}
	else {
		$reply = "Improper usage. Correct usage is: !warn [username]";
	}

	return $reply;
}
1;