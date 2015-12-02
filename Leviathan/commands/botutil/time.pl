#      .   .               <Leviathan>
#     .:...::     Command Name // !time
#    .::   ::.     Description // Get the current time.
# ..:;;. ' .;;:..        Usage // !time
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub time {
	my ($self,$client,$msg) = @_;

	# Get their time zone (if it exists).
	my $zone = $chaos->{clients}->{$client}->{time} || '';
	$zone = undef if $zone eq 'undefined';

	my $timedate  = &timestamps ('local','<day_name>, <month_name> <day_month> <year_full>');
	my $timelocal = &timestamps ('local','<hour_12>:<min>:<secs> <ext>');
	my $timegm    = &timestamps ('gm',   '<hour_12>:<min>:<secs> <ext>');
	my $timeuser  = '';

	# Get user's time.
	if (length $zone > 0) {
		$timeuser = &timestamps ('zone','<hour_12>:<min>:<secs> <ext>',$zone);
	}

	my $reply = ":: Time ::\n\n"
		. "Local Date: $timedate\n"
		. "Local Time: $timelocal\n"
		. "GM Time: $timegm";

	if (length $timeuser > 0) {
		$reply .= "\n"
			. "Your Time: $timeuser";
	}

	return $reply;
}
{
	Category => 'Bot Utilities',
	Description => 'Get the current time.',
	Usage => '!time',
	Listener => 'All',
};