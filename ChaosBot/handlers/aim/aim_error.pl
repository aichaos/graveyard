# AIM Handler: error
# Handles errors issued by the server.

sub aim_error {
	# Get server arguments from the shift.
	my ($aim,$conn,$error,$description,$fatal) = @_;

	my $time = localtime();

	my $screenname = $aim->screenname();

	if ($error == 10) {
		print "AIM error. Putting up away message.";

		$aim->set_away ("<body bgcolor=black><font face=Verdana color=yellow size=2>"
			. "My AIM client is having troubles right now. I'd prefer that"
			. "you talk to me on MSN, my e-mail is AzulianBot\@hotmail.com</font></body>");
	}

	print "$time\n";
	print "ChaosAIM: ERROR $error: $description\n\n";
}
1;