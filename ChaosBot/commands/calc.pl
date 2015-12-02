# COMMAND NAME:
#	CALC
# DESCRIPTION:
#	Simple calculator.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub calc {
	# Get variables from the shift.
	my ($client,$msg,$self) = @_;

	# Cut the command off.
	$msg =~ s/\!calc //ig;

	# Only respond if there are valid operators.
	if ($msg =~ /[^0-9\+\-\*\/\(\)\.\ ]/) {
		$reply = ("Invalid operators. Valid operators are:\n\n"
			. "+ - * / ( ). Ex: !calc 2/3*(4-5)");
	}
	else {
		$reply = "$msg = " . eval($msg);
	}

	return $reply;
}
1;