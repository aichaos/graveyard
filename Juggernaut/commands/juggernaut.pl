#      .   .             <CKS Juggernau	
#     .:...::     Command Name // !juggernaut
#    .::   ::.     Description // Specs on the Juggernaut bot.
# ..:;;. ' .;;:..        Usage // !juggernaut
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub juggernaut {
	my ($self,$client,$msg,$listener) = @_;

	# Get the version.
	my $VER = $chaos->{_system}->{version};
	my $AUT = $chaos->{_system}->{author};

	# Count the Bots.
	my @bots = ();
	foreach my $key (keys %{$chaos}) {
		if (exists $chaos->{$key}->{client} && exists $chaos->{$key}->{client}) {
			push (@bots, $key);
		}
	}

	return ":: Technical Information ::\n\n"
		. "Program: CKS Juggernaut v. $VER\n"
		. "Author: $AUT\n"
		. "Number of Connections: " . scalar(@bots) . "\n"
		. "[" . join (",", @bots) . "]\n\n"
		. "Copyright © 2004 Chaos AI Technology\n"
		. "http://www.aichaos.com/\n"
		. "juggernaut\@aichaos.com";
}

{
	Category    => 'General',
	Description => 'Juggernaut Technical Information',
	Usage       => '!juggernaut',
	Listener    => 'All',
};