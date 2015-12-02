# COMMAND NAME:
#	STATUS
# DESCRIPTION:
#	Gets current bot statistics.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub status {
	# Get info from the shift... like we REALLY need it.
	my ($client,$msg,$self) = @_;

	# Some ideas from this came from XENOANDROID.
	# <xenoandroid@verizon.net> http://www.xenouniverse.com

	# Set our starting variables.
	my $brain_count = 0;
	my $command_count = 0;
	my $warner_count = 0;
	my $blocked_count = 0;
	my $client_count = 0;

	# Get the "brain count"
	open (BRAIN, "data/brain.txt");
	my @brain = <BRAIN>;
	close (BRAIN);
	foreach $line (@brain) {
		$brain_count++;
	}

	# Get the command count.
	opendir (DIR, "./commands");
	foreach $file (sort(grep(!/^\./, readdir(DIR)))) {
		$command_count++;
	}
	closedir (DIR);

	# Get the warner and blocked counts.
	open (WARNERS, "data/warners.txt");
	my @warners = <WARNERS>;
	close (WARNERS);
	foreach $line (@warners) {
		$warner_count++;
	}
	open (BLOCKS, "data/blocked.txt");
	my @blocked = <BLOCKS>;
	close (BLOCKS);
	foreach $line (@blocked) {
		$blocked_count++;
	}

	# Get the total client count.
	opendir (DIR2, "logs/clients");
	foreach $file (sort(grep(!/^\./, readdir(DIR2)))) {
		$client_count++;
	}
	closedir (DIR2);

	# Reply with the statistics.
	$reply = ("~Current Statistics~\n\n"
		. "Lines in Reply Data: $brain_count\n"
		. "Number of Commands: $command_count\n"
		. "Number of Clients: $client_count\n"
		. "Number of Warners: $warner_count\n"
		. "Number of Blocked Users: $blocked_count\n"
		. "~ http://chaos.kirsle.net");
}
1;