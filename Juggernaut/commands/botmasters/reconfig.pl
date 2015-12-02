#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !reconfig
#    .::   ::.     Description // Reload your configuration files.
# ..:;;. ' .;;:..        Usage // !reconfig
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub reconfig {
	my ($self,$client,$msg,$listener) = @_;	

	# This command is Master Only.
	if (isMaster($client,$listener)) {
		# Delete existing data.
		delete $chaos->{_system}->{config} if exists $chaos->{_system}->{config};
		delete $chaos->{_system}->{substitution} if exists $chaos->{_system}->{substitution};
		delete $chaos->{_system}->{server} if exists $chaos->{_system}->{server};

		# Load the configuration data.
		open (STARTUP, "./config/startup.cfg");
		my @data = <STARTUP>;
		close (STARTUP);
		chomp @data;
		foreach my $line (@data) {
			my ($what,$is) = split(/=/, $line, 2);
			$what = lc($what);
			$what =~ s/ //g;
			$chaos->{_system}->{config}->{$what} = $is;
		}

		# Load the substitution data.
		open (SUBS, "./config/substitution.cfg");
		@data = <SUBS>;
		close (SUBS);
		chomp @data;
		my $lvl;
		foreach $line (@data) {
			($lvl,$what,$is) = split(/==/, $line, 3);
			$what = lc($what);
			$chaos->{_system}->{substitution}->{$what}->{level} = $lvl;
			$chaos->{_system}->{substitution}->{$what}->{replace} = $is;
		}

		# Load the server configuration.
		open (SERVER, "./config/server.cfg");
		@data = <SERVER>;
		close (SERVER);
		chomp @data;
		foreach $line (@data) {
			($what,$is) = split(/=/, $line, 2);
			$what = lc($what);
			$what =~ s/ //g;
			$chaos->{_system}->{server}->{$what} = $is;
		}

		return "All configuration files reloaded successfully.";
	}
	else {
		return "This command is Master Only.";
	}
}

{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Reloads Startup Configuration Files',
	Usage => '!reconfig',
	Listener => 'All',
};