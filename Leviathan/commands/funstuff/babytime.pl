#      .   .               <Leviathan>
#     .:...::     Command Name // !babytime
#    .::   ::.     Description // Time that a baby could understand.
# ..:;;. ' .;;:..        Usage // !babytime
#    .  '''  .     Permissions // Public.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub babytime {
	my ($self,$client,$msg) = @_;

	# Get the time.
	my ($secs,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
	my $ext = 'AM';
	$ext = 'PM' if $hour > 12;

	# Convert to 12-hour format.
	$hour -= 12 if $hour > 12;
	$min = '0' . $min if length $min == 1;

	# Calculate the big hand.
	my ($a,$b) = split(//, $min, 2);
	if ($b >= 3 && $b <= 7) {
		$b = 5;
	}
	elsif ($b < 3) {
		$b = 0;
	}
	else {
		$b = 0;
		$a++;
	}
	$min = $a . $b;

	# The hands.
	my $little = $hour;
	my $big = int(($min / 5));

	return "The big hand is pointing to the $big and the little hand is pointing to the $little.\n\n"
		. "(The time is really $hour:$min $ext)";
}
{
	Category    => 'Fun Stuff',
	Description => 'Time that a baby could understand.',
	Usage       => '!babytime',
	Listener    => 'All',
};