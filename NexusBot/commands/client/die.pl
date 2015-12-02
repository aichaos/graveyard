# COMMAND NAME:
#	DIE
# DESCRIPTION:
#	Roll an X sided die.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub die {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure they have a number to roll for.
	if ($msg) {
		my $result = int(rand($msg)) + 1;

		$reply = "I have rolled a $msg sided die and returned: $result.";
	}
	else {
		$reply = "The die command requires a number:\n\n!die 6";
	}

	return $reply;
}
1;