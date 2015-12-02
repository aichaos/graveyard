# COMMAND NAME:
#	UPDATES
# DESCRIPTION:
#	Check for recent updates.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub updates {
	my ($self,$client,$msg,$listener) = @_;

	# Send the recent updates.
	$reply = "<b>Recent Updates</b>\n\n"
		. "No new updates.";

	return $reply;
}
1;