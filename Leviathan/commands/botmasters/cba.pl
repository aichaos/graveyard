#      .   .               <Leviathan>
#     .:...::     Command Name // !cba
#    .::   ::.     Description // Search the bot's Alpha brain.
# ..:;;. ' .;;:..        Usage // !cba <message>
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2005 AiChaos Inc.

sub cba {
	my ($self,$client,$msg) = @_;

	# This command is Master Only.
	return "This command is Master Only!" unless &isMaster($client);

	my ($l,$c) = split(/\-/, $client, 2);

	my $sn;
	$sn = $self->screenname if $l eq 'AIM';
	$sn = $self->{Msn}->{Handle} if $l eq 'MSN';
	$sn = lc($sn);
	$sn =~ s/ //g;

	return "I don't have an Alpha brain" unless exists $chaos->{bots}->{$sn}->{_alpha};
	return "Give me a message to search with" unless length $msg;

	my @results = $chaos->{bots}->{$sn}->{_alpha}->search ($msg);

	my $reply = "Results:\n\n";
	foreach my $r (@results) {
		$reply .= "$r\n";
	}
	return $reply;
}
{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Search the Alpha brain.',
	Usage => '!cba <message>',
	Listener => 'All',
};