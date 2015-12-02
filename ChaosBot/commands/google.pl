# COMMAND NAME:
#	GOOGLE
# DESCRIPTION:
#	Generates a Google link.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub google {
	# Get variables from the shift.
	my ($client,$msg,$self) = @_;

	# Cut the command off.
	$msg =~ s/\!google //ig;

	# Convert spaces to pluses.
	$msg =~ s/ /\+/g;

	# Give 'em the URL.
	$reply = ("<b>Search URL:</b>\n"
		. "http://www.google.com/search?hl=en&ie=UTF-8&oe=UTF-8&q=$msg");

	return $reply;
}
1;