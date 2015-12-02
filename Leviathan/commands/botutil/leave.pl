#      .   .               <Leviathan>
#     .:...::     Command Name // !leave
#    .::   ::.     Description // Makes the bot leave a conversation.
# ..:;;. ' .;;:..        Usage // !leave
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // MSN
#     :     :        Copyright // 2005 AiChaos Inc.

sub leave {
	my ($self,$client,$msg) = @_;

	my ($listener,$nick) = split(/\-/, $client, 2);

	# Only applies to MSN.
	if ($listener eq 'MSN') {
		# Leave!
		$self->sendMessage ("Good-bye, room! :-(",
			Font   => 'Verdana',
			Color  => '990099',
			Effect => 'B',
		);
		my $sock = $self->getID;
		my $sn = $self->{Msn}->{Handle};
		$sn = lc($sn);
		$sn =~ s/ //g;
		&queue ($sn, 1, "my \$convo = \$chaos->{bots}->{'$sn'}->{client}->getConvo ($sock); "
			. "\$convo->leave();");
		return '<noreply>';
	}
	else {
		return "This command only applies to MSN.";
	}
}

{
	Category => 'Bot Utilities',
	Description => 'Forces me to leave the conversation.',
	Usage => '!leave',
	Listener => 'MSN',
};