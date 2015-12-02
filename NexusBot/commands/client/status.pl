# COMMAND NAME:
#	STATUS
# DESCRIPTION:
#	Gets current bot statistics.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub status {
	# Get info from the shift... like we REALLY need it.
	my ($self,$client,$msg,$listener) = @_;

	# Some ideas from this came from XENOANDROID.
	# <xenoandroid@verizon.net> http://www.xenouniverse.com

	# Set our starting variables.
	my $brain_line_count = 0;
	my $brain_item_count = 0;
	my $command_count = 0;
	my $warner_count = 0;
	my $blocked_count = 0;
	my $client_count = 0;

	# Get the "brain count"
	open (BRAIN, "data/brain.txt");
	my @brain = <BRAIN>;
	close (BRAIN);
	foreach $line (@brain) {
		chomp $line;
		$brain_line_count++;

		my ($in,$out) = split(/\]\[/, $line);
		my @in = split(/\|/, $in);
		my @out = split(/\|/, $out);
		foreach $item (@in) {
			$brain_item_count++;
		}
		foreach $item (@out) {
			$brain_item_count++;
		}
	}

	# Get the command count.
	opendir (CLIENT, "./commands/client");
	foreach $file (sort(grep(!/^\./, readdir(CLIENT)))) {
		$command_count++;
	}
	closedir (CLIENT);
	opendir (GIFTED, "./commands/gifted");
	foreach $file (sort(grep(!/^\./, readdir(GIFTED)))) {
		$command_count++;
	}
	closedir (GIFTED);
	opendir (KEEPER, "./commands/keeper");
	foreach $file (sort(grep(!/^\./, readdir(KEEPER)))) {
		$command_count++;
	}
	closedir (KEEPER);
	opendir (MOD, "./commands/moderator");
	foreach $file (sort(grep(!/^\./, readdir(MOD)))) {
		$command_count++;
	}
	closedir (MOD);
	opendir (SMOD, "./commands/supermoderator");
	foreach $file (sort(grep(!/^\./, readdir(SMOD)))) {
		$command_count++;
	}
	closedir (SMOD);
	opendir (ADMIN, "./commands/admin");
	foreach $file (sort(grep(!/^\./, readdir(ADMIN)))) {
		$command_count++;
	}
	closedir (ADMIN);
	opendir (SADMIN, "./commands/superadmin");
	foreach $file (sort(grep(!/^\./, readdir(SADMIN)))) {
		$command_count++;
	}
	closedir (SADMIN);
	opendir (MASTER, "./commands/master");
	foreach $file (sort(grep(!/^\./, readdir(MASTER)))) {
		$command_count++;
	}
	closedir (MASTER);

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
	$blocked_count = $blocked_count - 8;

	# Get the total client count.
	opendir (DIR2, "./clients");
	foreach $file (sort(grep(!/^\./, readdir(DIR2)))) {
		$client_count++;
	}
	closedir (DIR2);

	# Reply with the statistics.
	$reply = ("~Current Statistics~\n\n"
		. "Items in Reply Data: $brain_item_count\n"
		. "Lines in Reply Data: $brain_line_count\n"
		. "Number of Commands: $command_count\n"
		. "Number of Clients: $client_count\n"
		. "Number of Warners: $warner_count\n"
		. "Number of Blocked Users: $blocked_count\n"
		. "~ http://chaos.kirsle.net");

	return $reply;
}
1;