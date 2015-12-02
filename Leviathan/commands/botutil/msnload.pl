#      .   .               <Leviathan>
#     .:...::     Command Name // !msnload
#    .::   ::.     Description // Displays the MSN mirror loads.
# ..:;;. ' .;;:..        Usage // !msnload
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub msnload {
	my ($self,$client,$msg) = @_;

	# Get all the MSN bots.
	my $found = 0;
	my @bots = ();
	foreach my $bot (keys %{$chaos->{bots}}) {
		if ($chaos->{bots}->{$bot}->{listener} =~ /^msn$/i) {
			$found = 1;
			push (@bots, $bot);
		}
	}

	return "There are no MSN bots running at the moment." unless $found;

	# Get contact lists and start the reply.
	my @reply = ('MSN Mirror Loads', '');
	foreach my $bot (@bots) {
		my $msn = $chaos->{bots}->{$bot}->{client};
		my @rl = $msn->getContactList('RL');
		my $count = scalar(@rl);
		my $max = 400;
		my $percent = ($count / $max) * 100;
		$percent =~ s/\.(.)(.*?)/\.$1/ig;
		if ($percent !~ /\./) {
			$percent .= '.0';
		}
		push (@reply, "$bot: $count / $max ($percent\%)");
	}

	return join ("\n",@reply);
}
{
	Category => 'Bot Utilities',
	Description => 'Displays the MSN mirror loads.',
	Usage => '!msnload',
	Listener => 'All',
};