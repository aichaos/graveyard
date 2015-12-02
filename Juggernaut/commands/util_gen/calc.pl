#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !calc
#    .::   ::.     Description // A simple calculator.
# ..:;;. ' .;;:..        Usage // !calc <equation>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

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

{
	Category => 'General Utilities',
	Description => 'Simple Calculator',
	Usage => '!calc <equation>',
	Listener => 'All',
};