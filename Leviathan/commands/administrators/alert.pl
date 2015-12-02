#      .   .               <Leviathan>
#     .:...::     Command Name // !alert
#    .::   ::.     Description // Sends an MSN Sign-On Alert.
# ..:;;. ' .;;:..        Usage // !alert <message>
#    .  '''  .     Permissions // Administrator Only.
#     :;,:,;:         Listener // MSN
#     :     :        Copyright // 2005 AiChaos Inc.

sub alert {
	my ($self,$client,$msg) = @_;

	# Must be an admin.
	return "This command may only be used by Administrators and higher!" unless &isAdmin($client);

	# Get the messenger.
	my ($sender,$nick) = split(/\-/, $client, 2);

	# MSN only.
	return "This command is only for MSN." unless $sender eq 'MSN';

	# Must have a message.
	return "You must provide a message to send while using this command!" unless length $msg > 0;

	my $sn = $self->{Msn}->{Handle};
	$sn = lc($sn);
	$sn =~ s/ //g;

	my $msn = $chaos->{bots}->{$sn}->{client};

	# Alerts Emoticon.
	my $emo = '(I)';
	$emo = '(*)' if &isMaster($client);

	# Send the alert.
	$msn->setName ("$emo $msg\r\r\r");
	$msn->setStatus ('HDN');
	$msn->setStatus ('NLN');
	$msn->setName ($chaos->{bots}->{$sn}->{nick});

	return "I have sent the alert.";
}
{
	Restrict    => 'Administrators',
	Category    => 'Administrator Commands',
	Description => 'Sends an MSN Sign-On Alert.',
	Usage       => '!alert <message>',
	Listener    => 'MSN',
};