#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !status
#    .::   ::.     Description // Current bot statistics.
# ..:;;. ' .;;:..        Usage // !status
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub status {
	# Get info from the shift... like we REALLY need it.
	my ($self,$client,$msg,$listener) = @_;

	# HTTP will cause too many compatibility issues.
	if ($listener eq "HTTP") {
		# See if this is Chaos AI Technology's own bot.
		if (-e "./chaos.id" == 1) {
			return "To view my statistics, click the link below:\n\n"
				. "<a href=\"http://www.aichaos.com/?display=status\" target=\"_blank\">CKS "
				. "Current Statistics</a>.";
		}
		else {
			return "The status command isn't efficient via HTTP chat.";
		}
	}

	# Some ideas from this came from XENOANDROID.
	# <xenoandroid@verizon.net> http://www.xenouniverse.com

	# Emoticon to use to emphasize sections of statistics.
	my %emo = (
		MSN => '(CKS)',
		AIM => ':-)',
		other => '',
	);

	# Count every file.
	my @filefolders = (
		'./brains',
		'./commands',
		'./handlers/aim',
		'./handlers/msn',
		'./handlers/irc',
		'./handlers/http',
		'./subroutines',
	);
	my $perl_count = 0;
	foreach my $filefolder (@filefolders) {
		opendir (DIR, "$filefolder");
		foreach my $infile (sort(grep(!/^\./, readdir(DIR)))) {
			$perl_count++;
		}
		closedir (DIR);
	}

	my $sn;
	$sn = $self->screenname() if $listener eq "AIM";
	$sn = $self->{Msn}->{Handle} if $listener eq "MSN";
	$sn = $self->nick() if $listener eq "IRC";
	$sn = lc($sn);
	$sn =~ s/ //g;

	#######################################################
	## GENERAL STATISTICS                                ##
	#######################################################
	# Set our starting variables.
	my $bot_count = 0;
	my $cur_ver = $VERSION || $chaos->{_system}->{version};
	my $online = (time - $chaos->{_system}->{online});

	# Calculate our online time.
	my $days = 0;
	my $hours = 0;
	my $mins = 0;
	my $secs = 0;

	my $found = 0;
	while ($online > 0) {
		$secs++;

		if ($secs == 60) {
			$secs = 0;
			$mins++;
		}
		if ($mins == 60) {
			$mins = 0;
			$hours++;
		}
		if ($hours == 24) {
			$hours = 0;
			$days++;
		}

		$online--;
	}

	# Count the bots running.
	$bot_count = scalar @botnames;

	#######################################################
	## ITEM COUNTS STATISTICS                            ##
	#######################################################
	# Set our starting variables.
	my $reply_count = 0;
	my $command_count = 0;
	my $warner_count = 0;
	my $blocked_count = 0;
	my $black_count = 0;
	my $client_count = 0;
	my $p_block = 0;
	my $b_warn = 0;
	my $b_black = 0;

	# Get the reply count. First we need to determine the brain.
	my $brain = $chaos->{$sn}->{brain};
	$reply_count = status_get_reply_count ($brain,$sn);

	# Get the command count.
	$command_count = $chaos->{_data}->{commandcount};

	# Get the warner and blocked counts.
	open (WARNERS, "data/warners.txt");
	my @warners = <WARNERS>;
	close (WARNERS);
	foreach $line (@warners) {
		$warner_count++;
	}
	opendir (BLOCK, "./data/blocks");
	foreach my $file (sort(grep(!/^\./, readdir(BLOCK)))) {
		$blocked_count++;
	}
	closedir (BLOCK);
	open (BLOCKS, "data/blacklist.txt");
	my @blocked = <BLOCKS>;
	close (BLOCKS);
	foreach $line (@blocked) {
		$black_count++;
	}

	# Get the total client count.
	opendir (DIR2, "./clients");
	foreach $file (sort(grep(!/^\./, readdir(DIR2)))) {
		$client_count++;
	}
	closedir (DIR2);

	# Get the percentages.
	if ($client_count > 0) {

		if ($block_count > 0) {
			$p_block = ($block_count / $client_count) * 100;
			$p_block =~ s/\.(\d+)//ig;
		}
		else {
			$p_block = 0;
		}

		if ($warner_count > 0) {
			$p_warn = ($warner_count / $client_count) * 100;
			$p_warn =~ s/\.(\d+)//ig;
		}
		else {
			$p_warn = 0;
		}

		if ($black_count > 0) {
			$p_black = ($black_count / $client_count) * 100;
			$p_black =~ s/\.(\d+)//ig;
		}
		else {
			$p_black = 0;
		}

	}
	else {
		$p_block = 0;
		$p_warn = 0;
		$p_black = 0;
	}

	$p_block .= '%';
	$p_warn .= '%';
	$p_black .= '%';

	# Reply with the statistics.
	my $reply = "~CKS Juggernaut Current Statistics~\n\n"
		. "<emo> === General Statistics === <emo>\n"
		. "Juggernaut Version\n\t"
			. "// $chaos->{_system}->{version}\n"
		. "Online Time\n\t"
			. "// $days Days, $hours Hours, $mins Minutes and $secs Seconds\n"
		. "\# Bots Connected\n\t"
			. "// $bot_count\n\n"
		. "<emo> === Item Counts === <emo>\n"
		. "Number of Perl Files\n\t"
			. "// $perl_count\n"
		. "Reply Count (Brain: $brain)\n\t"
			. "// $reply_count\n"
		. "Commands\n\t"
			. "// $command_count\n"
		. "Clients\n\t"
			. "// $client_count\n"
		. "Warners\n\t"
			. "// $warner_count   [$p_warn]\n"
		. "Blocked Users\n\t"
			. "// $blocked_count   [$p_block]\n"
		. "Blacklisted Users\n\t"
			. "// $black_count   [$p_black]";

	# Convert emoticons.
	if (exists $emo{$listener}) {
		$reply =~ s/<emo>/$emo{$listener}/ig;
	}
	else {
		$reply =~ s/<emo>/$emo{other}/ig;
	}

	return $reply;
}
sub status_get_reply_count {
	# Get the brain from the shift.
	my ($brain,$sn) = @_;

	# Format the brain.
	$brain = lc($brain);
	$brain =~ s/ //g;

	# Only certain brains have support for reply counting.
	if ($brain eq 'juggernaut') {
		return $chaos->{$sn}->{_data}->{replycount};
	}
	elsif ($brain eq 'chaosml') {
		# Count the replies?
		my $cml = $chaos->{$sn}->{_data}->{brain};

		my $cml_count = 0;
		foreach my $key (keys %{$cml}) {
			if (exists $cml->{$key}->{pattern} && exists $cml->{$key}->{template}) {
				$cml_count++;
			}
		}

		# Return the count.
		return $cml_count;
	}
	elsif ($brain eq 'nexus') {
		# Count the Nexus brain's files.
		open (NEXUS, "$chaos->{$sn}->{reply}") or return "Unknown";
		my @data = <NEXUS>;
		close (NEXUS);

		chomp @data;

		my $nexus_count = 0;
		foreach my $line (@data) {
			my ($left,$right) = split(/\]\[/, $line, 2);
			my @a = split(/\|/, $left);
			my @b = split(/\|/, $right);

			$nexus_count += scalar(@a);
			$nexus_count += scalar(@b);
		}

		# Return the count.
		return $nexus_count;
	}
	else {
		# Return N/A
		return 'N/A';
	}
}

{
	Category => 'General',
	Description => 'Current bot statistics',
	Usage => '!status',
	Listener => 'All',
};