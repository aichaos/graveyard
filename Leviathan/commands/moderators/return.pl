#      .   .               <Leviathan>
#     .:...::     Command Name // !return
#    .::   ::.     Description // Returns the bot from away status.
# ..:;;. ' .;;:..        Usage // !return
#    .  '''  .     Permissions // Moderator Only.
#     :;,:,;:         Listener // AIM,MSN
#     :     :        Copyright // 2005 AiChaos Inc.

sub return {
	my ($self,$client,$msg) = @_;

	# Must be a moderator.
	return "This command may only be used by Moderators and higher!" unless &isMod($client);

	# Get the messenger.
	my ($sender,$nick) = split(/\-/, $client, 2);

	# AIM and MSN only.
	unless ($sender =~ /^(AIM|MSN)$/i) {
		return "This command only applies to AIM and MSN.";
	}

	my $sn;
	$sn = $self->{Msn}->{Handle} if $sender eq 'MSN';
	$sn = $self->screenname() if $sender eq 'AIM';
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Messenger Statuses.
	if ($sender eq 'MSN') {
		my $msn = $chaos->{bots}->{$sn}->{client};

		$msn->setStatus ('NLN');

		return "I have returned.";
	}
	elsif ($sender eq 'AIM') {
		$chaos->{bots}->{$sn}->{client}->set_away ($awaymsg);

		return "I have returned.";
	}

	return "Unknown error: could not determine your messenger.";
}
{
	Restrict    => 'Moderators',
	Category    => 'Moderator Commands',
	Description => 'Returns the bot from away status.',
	Usage       => '!return',
	Listener    => 'All',
};