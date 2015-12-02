#      .   .               <Leviathan>
#     .:...::     Command Name // !away
#    .::   ::.     Description // Sets the bot's status to away.
# ..:;;. ' .;;:..        Usage // !away [message]
#    .  '''  .     Permissions // Moderator Only.
#     :;,:,;:         Listener // AIM,MSN
#     :     :        Copyright // 2005 AiChaos Inc.

sub away {
	my ($self,$client,$msg) = @_;

	# Must be a moderator.
	return "This command may only be used by Moderators and higher!" unless &isMod($client);

	# Get the messenger.
	my ($sender,$nick) = split(/\-/, $client, 2);

	# AIM and MSN only.
	unless ($sender =~ /^(AIM|MSN)$/i) {
		return "This command only applies to AIM and MSN.";
	}

	# Away messages.
	if ($sender eq 'AIM' && length $msg == 0) {
		$msg = 'I am away from my computer at the moment.';
	}
	elsif ($sender eq 'MSN' && length $msg == 0) {
		$msg = 'AWY';
	}

	my $sn;
	$sn = $self->{Msn}->{Handle} if $sender eq 'MSN';
	$sn = $self->screenname() if $sender eq 'AIM';
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Messenger Statuses.
	if ($sender eq 'MSN') {
		$msg = 'BSY' if $msg =~ /busy/i;
		$msg = 'IDL' if $msg =~ /idle/i;
		$msg = 'BRB' if $msg =~ /be right back/i;
		$msg = 'PHN' if $msg =~ /phone/i;
		$msg = 'LUN' if $msg =~ /lunch/i;

		$msg = uc($msg);

		my $msn = $chaos->{bots}->{$sn}->{client};

		if ($msg =~ /^(BSY|IDL|BRB|PHN|LUN)$/i) {
			$msn->setStatus ($msg);
		}
		else {
			$msn->setStatus ('AWY');
		}

		return "I have set my away status.";
	}
	elsif ($sender eq 'AIM') {
		# Get fonts.
		my ($font,$smile) = &get_font ($sn,'AIM');
		my $awaymsg = $font . $msg;
		$chaos->{bots}->{$sn}->{client}->set_away ($awaymsg);

		return "I have left the away message.";
	}

	return "Unknown error: could not determine your messenger.";
}
{
	Restrict    => 'Moderators',
	Category    => 'Moderator Commands',
	Description => 'Sets the bot\'s status to away.',
	Usage       => '!away [message or status]',
	Listener    => 'All',
};