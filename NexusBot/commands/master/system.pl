# COMMAND NAME:
#	SYSTEM
# DESCRIPTION:
#	Executes system commands.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub system {
	my ($self,$client,$msg,$listener) = @_;

	# Cut the command off..
	my $sym = get_comm_code();
	my $comm = ($sym . "system");
	$msg =~ s/$comm //ig;
	$msg =~ s/$comm//ig;

	# Make sure we have a system command to execute.
	if ($msg) {
		# As an extra security precaution, disallow usage in
		# the WINDOWS or PROGRAM FILES directories.
		if ($msg =~ /windows/i || $msg =~ /progra\~1/i) {
			$reply = "Sorry, Windows & Program Files are disallowed.";
		}
		else {
			system ($msg);
			$reply = "I have executed the system command.\n\n$msg";
		}
	}
	else {
		$reply = "Incorrect usage. Use like !system [command]";
	}

	return $reply;
}
1;