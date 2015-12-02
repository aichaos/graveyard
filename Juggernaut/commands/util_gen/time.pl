#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !time
#    .::   ::.     Description // Display the server's local time.
# ..:;;. ' .;;:..        Usage // !time
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub time {
	# Get variables from the shift.
	my ($self,$client,$msg,$listener) = @_;

	# Get basic times.
	my $timedate  = &get_date ('local','<day_name>, <month_name> <day_month> <year_full>');
	my $timelocal = &get_date ('local','<hour_12>:<min> <ext> or <hour_24>:<min>:<secs>');
	my $timegmt   = &get_date ('gm',   '<hour_12>:<min> <ext> or <hour_24>:<min>:<secs>');
	my $timeuser;

	# If the user has a time zone...
	my $usertime = $chaos->{_users}->{$client}->{time};
	undef $usertime if $usertime eq 'undefined';
	undef $usertime if length $usertime == 0;

	# Get user's time.
	if (defined $usertime && length $usertime > 0) {
		$timeuser = &get_date ('zone','<hour_12>:<min> <ext> or <hour_24>:<min>:<secs>',$usertime);
	}

	my $reply = "Local Date: $timedate\n"
		. "Server Time: $timelocal\n"
		. "GM Time: $timegmt";

	if (defined $usertime) {
		$reply .= "\n\n"
			. "Your Local Time ($usertime): $timeuser";
	}

	return $reply;
}

{
	Category => 'General Utilities',
	Description => 'Bot Host\'s Local Time',
	Usage => '!time',
	Listener => 'All',
};