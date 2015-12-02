#      .   .               <Leviathan>
#     .:...::     Command Name // !pi
#    .::   ::.     Description // Value of Pi from 2 to 500 decimals.
# ..:;;. ' .;;:..        Usage // !pi [length]
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub pi {
	my ($self,$client,$msg) = @_;

	my $size = $msg || 2;

	# Return if message is not valid.
	return "Give me a NUMBER of decimal places between 2 and 500." if $msg =~ /[^0-9]/;

	# Only accept values between 2 and 500.
	if ($size < 2 || $size > 500) {
		return "I will only do pi to decimal places between 2 and 500.";
	}

	# The value of pi to 500 decimals.
	my $pi = "14159265358979323846264338327950288419716939937510"
		. "58209749445923078164062862089986280348253421170679"
		. "82148086513282306647093844609550582231725359408128"
		. "48111745028410270193852110555964462294895493038196"
		. "44288109756659334461284756482337867831652712019091"
		. "45648566923460348610454326648213393607260249141273"
		. "72458700660631558817488152092096282925409171536436"
		. "78925903600113305305488204665213841469519415116094"
		. "33057270365759591953092186117381932611793105118548"
		. "07446237996274956735188575272489122793818301194912";

	# Prepare some variables.
	my $result = '3.';
	my $count = $size;

	# Make an array of digits.
	my @nums = split(//, $pi);

	# Go through each digit.
	foreach my $digit (@nums) {
		if ($count >= 1) {
			$result .= $digit;
			$count--;
		}
	}

	# Return the result.
	return "Value of Pi to $size places:\n$result";
}
{
	Category => 'Utilities',
	Description => 'Value of Pi from 2 to 500 decimals.',
	Usage => '!pi [length]',
	Listener => 'All',
};