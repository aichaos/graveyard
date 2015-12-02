# COMMAND NAME:
#	PERL
# DESCRIPTION:
#	Execute Perl functions.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub perl {
	my ($self,$client,$msg,$listener) = @_;

	# Cut the command off..
	my $sym = get_comm_code();
	my $comm = ($sym . "perl");
	$msg =~ s/$comm //ig;
	$msg =~ s/$comm//ig;

	# Convert HTML symbols.
	$msg =~ s/\&quot\;/"/ig;
	$msg =~ s/\&apos\;/'/ig;
	$msg =~ s/\&lt\;/</ig;
	$msg =~ s/\&gt\;/>/ig;
	$msg =~ s/\&amp\;/\&/ig;

	# Execute the Perl command.
	if ($msg) {
		eval ($msg);
		$reply = "I have executed the Perl function.\n\n$msg";
	}
	else {
		$reply = "You must put a Perl command in your message.\n\n!perl print \"Hello!\\n\\n\" ";
	}

	# Return the reply.
	return $reply;
}
1;