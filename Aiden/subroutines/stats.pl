# stats.pl - Get Bot Stats

sub stats {
	# Array of stats.
	my ($version,$numBots,@bots,$clients,$blocked,$blockP,$warners,$warnP,$black,$blackP);
	$numBots = 0;
	$clients = 0;
	$blocked = 0;
	$blockP = 0;
	$warners = 0;
	$warnP = 0;
	$black = 0;
	$blackP = 0;

	$version = $aiden->{version};

	$numBots = scalar(keys %{$aiden->{bots}});
	@bots = keys %{$aiden->{bots}};

	$clients = scalar(keys %{$aiden->{clients}});

	foreach my $client (keys %{$aiden->{clients}}) {
		my ($b,$desc) = &isBlocked($client);
		my ($w) = &isWarner($client);
		if ($b) {
			if ($desc =~ /blacklist/i) {
				$black++;
			}
			else {
				$blocked++;
			}
		}
		if ($w) {
			$warners++;
		}
	}

	# Percentages.
	$blockP = ($blocked / $clients) * 100;
	$warnP  = ($warners / $clients) * 100;
	$blackP = ($black   / $clients) * 100;
	$blockP =~ s/\.(\d.).*?$/\.$1/g;
	$warnP =~ s/\.(\d.).*?$/\.$1/g;
	$blackP =~ s/\.(\d.).*?$/\.$1/g;

	$blockP .= '%';
	$warnP  .= '%';
	$blackP .= '%';

	# Reply counts.
	my $replies = $aiden->{rive}->{sort}->{replycount};
	my $last = $aiden->{data}->{lastclient} || 'n/a';

	# Uptime.
	my $uptime = time() - $^T;
	my ($hours,$mins,$s) = (0,0,0);
	while ($uptime > 0) {
		$uptime--;
		$s++;

		if ($s == 60) {
			$s = 0;
			$mins++;
		}
		if ($mins == 60) {
			$mins = 0;
			$hours++;
		}
	}

	# Return it all.
	return (
		$version,
		$numBots,
		join (", ",@bots),
		$replies,
		$last,
		$clients,
		$blocked,
		$blockP,
		$warners,
		$warnP,
		$black,
		$blackP,
		"$hours:$mins:$s",
	);
}
1;