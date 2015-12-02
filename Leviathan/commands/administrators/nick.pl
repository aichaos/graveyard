#      .   .               <Leviathan>
#     .:...::     Command Name // !nick
#    .::   ::.     Description // Sets an MSN bot's nickname.
# ..:;;. ' .;;:..        Usage // !nick <new name>
#    .  '''  .     Permissions // Administrator Only.
#     :;,:,;:         Listener // MSN
#     :     :        Copyright // 2005 AiChaos Inc.

sub nick {
	my ($self,$client,$msg) = @_;

	# Must be an admin.
	return "This command may only be used by Administrators and higher!" unless &isAdmin($client);

	# Get the messenger.
	my ($sender,$nick) = split(/\-/, $client, 2);

	# MSN only.
	return "This command is only for MSN." unless $sender eq 'MSN';

	my $sn = $self->{Msn}->{Handle};
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Set the nickname.
	return "You must provide a nickname to set!" unless length $msg > 0;
	$chaos->{bots}->{$sn}->{client}->setName ($msg);
	return "My name has been set.";
}
{
	Restrict    => 'Administrators',
	Category    => 'Administrator Commands',
	Description => 'Sets an MSN bot\'s nickname.',
	Usage       => '!nick <new name>',
	Listener    => 'MSN',
};