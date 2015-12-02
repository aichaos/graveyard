#      .   .               <Leviathan>
#     .:...::     Command Name // !calc
#    .::   ::.     Description // Simple Calculator.
# ..:;;. ' .;;:..        Usage // !calc
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub calc {
	my ($self,$client,$msg) = @_;

	# Set callback.
	$chaos->{clients}->{$client}->{callback} = "calc";

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
	Category => 'Utilities',
	Description => 'Simple Calculator.',
	Usage => '!calc <equation>',
	Listener => 'All',
};