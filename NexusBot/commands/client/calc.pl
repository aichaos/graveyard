# COMMAND NAME:
#	CALC
# DESCRIPTION:
#	Simple calculator.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub calc {
	# Get variables from the shift.
	my ($self,$client,$msg,$listener) = @_;

	# Replace/insert special objects.
	$msg =~ s/pi/3.14/ig; # Pi
	$msg =~ s/\^/**/ig;   # Powers

	# Only respond if there are valid operators.
	if ($msg =~ /[^0-9\+\-\*\/\(\)\.\ ]/) {
		$reply = ("Invalid operators. Valid operators are:\n\n"
			. "+ - * / ( ). Ex: !calc 2 / 3 * (4 - 5) ^2");
	}
	else {
		my $calc = $msg;
		$calc =~ s/3.14/pi/ig;
		$calc =~ s/\*\*/\^/ig;
		$reply = "$calc = " . eval($msg);
	}

	return $reply;
}
1;