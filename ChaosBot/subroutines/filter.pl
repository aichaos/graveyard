# Subroutine: filter
# Filters punctuation out of the message.

sub filter {
	# Get the message from the shift.
	my $msg = shift;

	$msg =~ s/\.//g;   # .
	$msg =~ s/\,//g;   # ,
	$msg =~ s/\!//g;   # !
	$msg =~ s/\?//g;   # ?
	$msg =~ s/\://g;   # :
	$msg =~ s/\;//g;   # ;
	$msg =~ s/\-//g;   # -
	$msg =~ s/\+//g;   # +
	$msg =~ s/\///g;   # /
	$msg =~ s/\\//g;   # \
	$msg =~ s/\@//g;   # @
	$msg =~ s/\#//g;   # #
	$msg =~ s/\$//g;   # $
	$msg =~ s/\%//g;   # %
	$msg =~ s/\^//g;   # ^
	$msg =~ s/\&//g;   # &
	$msg =~ s/\*//g;   # *
	$msg =~ s/\=//g;   # =

	# Return the new message.
	return $msg;
}
1;