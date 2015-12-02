#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !info
#    .::   ::.     Description // Get your current info (points, stars, etc.)
# ..:;;. ' .;;:..        Usage // !info
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub info {
	my ($self,$client,$msg,$listener) = @_;

	if (length $msg > 0) {
		if ($msg =~ /point/i) {
			return ":: Points ::\n\n"
				. "Points can be earned by playing games on the bot (type !pinfo for "
				. "a list of games). You can in turn trade points for prizes in the "
				. "!shop command.";
		}
		elsif ($msg =~ /star/i) {
			return ":: Stars ::\n\n"
				. "Stars are a record kept by the bot for each user. All users start "
				. "with zero stars, and each time the bot blocks them they have one "
				. "star taken away (into the negatives). When a user has -5 stars and "
				. "the bot has to block them, they are then banned permanently.";
		}
		elsif ($msg =~ /time|zone/i) {
			return ":: Time Zones ::\n\n"
				. "The Time Zone Command (!tz) is a way in which the bot can record your "
				. "time zone. The reason is that the bot's server may not be in the same "
				. "time zone as you are, so if there are any time-based alarms, the bot "
				. "may alert you at the wrong times because it would be based on its own "
				. "local time zone.";
		}
		else {
			$msg = "Invalid item number. Type !info <lt>item<gt>, or type just !info to see "
				. "your current statistics.";
		}
	}

	# Get some basic data.
	my $points = $chaos->{_users}->{$client}->{points};
	my $stars = $chaos->{_users}->{$client}->{stars};
	my $zone = $chaos->{_users}->{$client}->{time};

	my $reply = "User Info For $client\n\n"
		. "Points: $points\n"
		. "Stars: $stars\n\n";

	if ($zone ne 'undefined') {
		$reply .= "The time zone we have on record for you is $zone.\n\n";
	}
	else {
		$reply = "I don't have your time zone on record. You can type !tz "
			. "to find your time zone.\n\n";
	}

	$reply .= "If you want more information on what points, stars, and time zones are, "
		. "type \"!info <lt>area<gt>\" for that area (i.e. !info points, !info stars, "
		. "!info time zones)";

	return $reply;
}

{
	Category => 'Points Earning',
	Description => 'Get your user info',
	Usage => '!info',
	Listener => 'All',
};