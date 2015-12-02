#              ::.                   .:.
#               .;;:  ..:::::::.  .,;:
#                 ii;,,::.....::,;;i:
#               .,;ii:          :ii;;:
#             .;, ,iii.         iii: .;,
#            ,;   ;iii.         iii;   :;.
# .         ,,   ,iii,          ;iii;   ,;
#  ::       i  :;iii;     ;.    .;iii;.  ,,      .:;
#   .,;,,,,;iiiiii;:     ,ii:     :;iiii;;i:::,,;:
#     .:,;iii;;;,.      ;iiii:      :,;iiiiii;,:
#          :;        .:,,:..:,,.        .:;..
#           i.                  .        ,:
#           :;.         ..:...          ,;
#            ,;.    .,;iiiiiiii;:.     ,,
#             .;,  :iiiii;;;;iiiii,  :;:
#                ,iii,:        .,ii;;.
#                ,ii,,,,:::::::,,,;i;
#                ;;.   ...:.:..    ;i
#                ;:                :;
#                .:                ..
#                 ,                :
#  Subroutine: statistics
# Description: Returns an array of the bot's statistics.

sub statistics {
	# Get the sign-on and activity times.
	my $signon = $chaos->{system}->{signon};
	my $active = time();

	# Calculate the time in between.
	my ($days,$hours,$mins,$secs) = (0,0,0,0);
	my $ticker = ($active - $signon);
	while ($ticker > 0) {
		$secs++;
		$ticker--;

		# Minutes.
		if ($secs == 60) {
			$secs = 0;
			$mins++;
		}
		# Hours.
		if ($mins == 60) {
			$mins = 0;
			$hours++;
		}
		# Days.
		if ($hours == 24) {
			$hours = 0;
			$days++;
		}
	}

	# Count (and get) the connected bots.
	my @names = ();
	foreach my $key (keys %{$chaos->{bots}}) {
		if (exists $chaos->{bots}->{$key}->{listener}) {
			push (@names, $key);
		}
	}
	my $countBots = scalar(@names);

	# Count the commands.
	my @commands = keys %{$chaos->{system}->{commands}};
	my $countCommands = scalar(@commands);

	# Count the users.
	my $countUsers = 0;
	opendir (DIR, "./clients");
	foreach my $file (sort(grep(!/^\./, readdir(DIR)))) {
		$countUsers++;
	}
	closedir (DIR);

	# Count the warners.
	my $countWarners = 0;
	open (WARN, "./data/warners.txt");
	my @warn = <WARN>;
	close (WARN);
	chomp @warn;
	$countWarners = scalar(@warn);

	# Count the blacklisted.
	my $countBlacklist = 0;
	open (LIST, "./data/blacklist.txt");
	my @list = <LIST>;
	close (LIST);
	chomp @list;
	$countBlacklist = scalar(@list);

	# Count the blocked users.
	my $countBlocked = 0;
	foreach my $user (keys %{$chaos->{clients}}) {
		if ($chaos->{clients}->{$user}->{blocked} == 1) {
			$countBlocked++;
		}
	}

	# Get the percentages of these bad users to total users.
	my $percentWarn = '0.000';
	my $percentBlack = '0.000';
	my $percentBlock = '0.000';
	if ($countWarners > 0) {
		$percentWarn = ($countWarners / $countUsers) * 100;
	}
	if ($countBlacklist > 0) {
		$percentBlack = ($countBlacklist / $countUsers) * 100;
	}
	if ($countBlocked > 0) {
		$percentBlock = ($countBlocked / $countUsers) * 100;
	}

	# Only float to three decimal places.
	$percentWarn =~ s/\.(\d..)(.*?)$/\.$1/ig;
	$percentBlack =~ s/\.(\d..)(.*?)$/\.$1/ig;
	$percentBlock =~ s/\.(\d..)(.*?)$/\.$1/ig;

	$percentWarn .= '%';
	$percentBlack .= '%';
	$percentBlock .= '%';

	# Get last user data.
	

	# Return data.
	my @returned = ("Version = $chaos->{version}",
		"Online = true",
		"Time = $days:$hours:$mins:$secs",
		"SignedOn = $chaos->{system}->{signon}",
		"BotCount = $countBots",
		"BotNames = " . join(",", @names),
		"CommandCount = $countCommands",
		"ClientCount = $countUsers",
		"LastClient = $chaos->{system}->{last_client}",
		"LastMsgOn = $chaos->{system}->{last_msg_on}",
		"WarnerCount = $countWarners",
		"WarnerPercent = $percentWarn",
		"BlacklistCount = $countBlacklist",
		"BlacklistPercent = $percentBlack",
		"BlockedCount = $countBlocked",
		"BlockedPercent = $percentBlock",
	);

	return @returned;
}
{
	Type        => 'subroutine',
	Name        => 'statistics',
	Usage       => '@stats = &statistics()',
	Description => 'Returns an array of the bot\'s statistics.',
	Author      => 'Cerone Kirsle',
	Created     => '12:15 PM 12/18/2004',
	Updated     => '12:22 PM 12/18/2004',
	Version     => '1.0',
};