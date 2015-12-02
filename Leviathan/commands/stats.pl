#      .   .               <Leviathan>
#     .:...::     Command Name // !stats
#    .::   ::.     Description // Get the bot's statistics.
# ..:;;. ' .;;:..        Usage // !stats
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub stats {
	my ($self,$client,$msg) = @_;

	# Get the statistics.
	my @stats = &statistics ();

	# Parse through them.
	my %stats = ();
	foreach my $line (@stats) {
		my ($what,$is) = split(/ = /, $line, 2);
		$stats{$what} = $is;
	}

	# Get the online time.
	my ($days,$hours,$mins,$secs) = split(/:/, $stats{Time}, 4);

	# Return the reply.
	return ":: Current Statistics ::\n\n"
		. "Leviathan Version\n"
		. "      $stats{Version}\n"
		. "Online Time\n"
		. "      $days days, $hours hours, $mins minutes\n"
		. "Bots Connected\n"
		. "      $stats{BotCount}\n\n"
		. "Number of Commands\n"
		. "      $stats{CommandCount}\n"
		. "Number of Users\n"
		. "      $stats{ClientCount}\n"
		. "Number of AIM Warners\n"
		. "      $stats{WarnerCount} ($stats{WarnerPercent})\n"
		. "Number of Blacklisted Users\n"
		. "      $stats{BlacklistCount} ($stats{BlacklistPercent})\n"
		. "Number of Blocked Users\n"
		. "      $stats{BlockedCount} ($stats{BlockedPercent})";
}

{
	Category => 'General',
	Description => 'Current bot statistics.',
	Usage => '!stats',
	Listener => 'All',
};