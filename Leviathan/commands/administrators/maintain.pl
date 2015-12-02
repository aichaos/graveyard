#      .   .               <Leviathan>
#     .:...::     Command Name // !maintain
#    .::   ::.     Description // Handles Maintenance Mode.
# ..:;;. ' .;;:..        Usage // !maintain <on|off|message [msg]>
#    .  '''  .     Permissions // Administrator Only.
#     :;,:,;:         Listener // AIM,MSN
#     :     :        Copyright // 2005 AiChaos Inc.

sub maintain {
	my ($self,$client,$msg) = @_;

	# Must be an admin.
	return "This command may only be used by Administrators and higher!" unless &isAdmin($client);

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

	# Must have a command.
	unless ($msg =~ /^(on|off|message)/i) {
		return "Invalid command use! Valid subcommands are: ON, OFF, MESSAGE. Maintenance "
			. "messages must be set before activating maintenance mode.";
	}

	# Go through actions.
	$msg = lc($msg);

	my $aim = $chaos->{bots}->{$sn}->{client} if $sender eq 'AIM';
	my $msn = $chaos->{bots}->{$sn}->{client} if $sender eq 'MSN';

	$chaos->{system}->{maintain}->{msg} = 'The bot is currently under maintenance mode!'
		unless length $chaos->{system}->{maintain}->{msg} > 0;

	if ($msg eq "on") {
		# Turn on maintenance mode.
		$chaos->{system}->{maintain}->{on} = 1;
		foreach my $bot (keys %{$chaos->{bots}}) {
			my $lis = $chaos->{bots}->{$bot}->{listener};
			$lis = uc($lis);
			if ($lis eq 'MSN') {
				my $nick = $chaos->{bots}->{$bot}->{nick} || 'AiChaos Leviathan';
				$nick .= ' (Maintenance Mode)';

				$chaos->{bots}->{$bot}->{client}->setName ($nick);
				$chaos->{bots}->{$bot}->{client}->setStatus ('AWY');
			}
			elsif ($lis eq 'AIM') {
				my ($font,$smile) = &get_font ($bot,'AIM');
				my $away = $font . $chaos->{system}->{maintain}->{msg};
				$chaos->{bots}->{$bot}->{client}->set_away ($away);
			}
		}

		return "Maintenance mode is now activated.";
	}
	elsif ($msg eq "off") {
		# Turn it off.
		$chaos->{system}->{maintain}->{on} = 0;
		foreach my $bot (keys %{$chaos->{bots}}) {
			my $lis = $chaos->{bots}->{$bot}->{listener};
			$lis = uc($lis);

			if ($lis eq 'MSN') {
				my $nick = $chaos->{bots}->{$bot}->{nick} || 'AiChaos Leviathan';

				$chaos->{bots}->{$bot}->{client}->setName ($nick);
				$chaos->{bots}->{$bot}->{client}->setStatus ('NLN');
			}
			elsif ($lis eq 'AIM') {
				$chaos->{bots}->{$bot}->{client}->set_away ('');
			}
		}

		return "Maintenance mode is now deactivated.";
	}
	elsif ($msg =~ /^message/i) {
		# Set the message.
		my ($cmd,$text) = split(/ /, $msg, 2);
		return "You didn't provide a message to set!" unless length $text > 0;

		$chaos->{system}->{maintain}->{msg} = $text;
		return "The message has been set.";
	}
	else {
		return "Invalid command: unknown error.";
	}

	return "Unknown error: could not determine your messenger.";
}
{
	Restrict    => 'Administrators',
	Category    => 'Administrator Commands',
	Description => 'Handles Maintenance Mode.',
	Usage       => '!maintain <on|off|message [msg]>',
	Listener    => 'AIM,MSN',
};