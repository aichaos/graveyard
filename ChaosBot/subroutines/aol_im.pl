# Subroutine: aol_im
# Sends the Instant Message.

sub aol_im {
	my ($client,$reply,$aim) = @_;

	# Convert \n to <br>.
	$reply =~ s/\n/<br>/ig;

	$aim->send_im ($client,$reply);
}
1;