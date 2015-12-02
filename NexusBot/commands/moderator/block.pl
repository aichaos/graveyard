# COMMAND NAME:
#	BLOCK
# DESCRIPTION:
#	Adds a user to the blocked list.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub block {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we have somebody TO block.
	if ($msg) {
		# Add them to the blocked list.
		open (LIST, ">>./data/blocked.txt");
		print LIST "$msg\n";
		close (LIST);

		$reply = "I have added $msg to the blocked list.";
	}
	else {
		$reply = "Improper usage. Correct usage is: !block [username]";
	}

	return $reply;
}
1;