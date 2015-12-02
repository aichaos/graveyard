#      .   .               <Leviathan>
#     .:...::     Command Name // !sayto
#    .::   ::.     Description // Send a plain message to somebody.
# ..:;;. ' .;;:..        Usage // !sayto <screenname|username> <message>
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2005 AiChaos Inc.

sub sayto {
	my ($self,$client,$msg) = @_;

	# This command is Master Only.
	return "This command is Master Only!" unless &isMaster($client);

	my ($to,$message) = split(/\s+/, $msg, 2);
	return "Provide a message to send!" unless defined $message;
	my $target = undef; # Final name of the target.
	my $host = undef;

	# TO can be just a screenname if it's somebody on the same messenger, or their
	#    full username if on another messenger.
	my ($lis,$name) = split(/\-/, $to, 2);
	if (not defined $name) {
		# Just using a screenname.
		my ($listener,$myname) = split(/\-/, $client, 2); # Get user's own listener.
		$name = lc($lis);
		$name =~ s/ //g;
		$listener = uc($listener);
		$target = join ('-', $listener, $name);

		$host = $self->screenname if $listener eq 'AIM';
		$host = $self->{botscreenname} if $listener eq 'TOC';
		$host = $self->{Msn}->{Handle} if $listener eq 'MSN';
		$host = $self->nick if $listener eq 'IRC';
		$host = $self->{username} if $listener eq 'JABBER';
		$host = $self->{username} if $listener eq 'YAHOO';
		$host = lc($host);
		$host =~ s/ //g;
	}
	else {
		# Full username was provided.
		$lis = uc($lis); $lis =~ s/ //g;
		$name = lc($name); $name =~ s/ //g;
		$target = join ('-', $lis, $name);
	}

	# Only send to valid listeners.
	return "I can't send messages to that listener." unless $target =~ /^(AIM|MSN|IRC|YAHOO|JABBER)\-/i;

	# Find a host.
	if (not defined $host) {
		my ($tl,$tn) = split(/\-/, $target, 2);
		foreach my $bot (keys %{$chaos->{bots}}) {
			if (uc($chaos->{bots}->{$bot}->{listener}) eq $tl) {
				$host = $bot;
				last;
			}
		}
	}

	if (defined $host) {
		$chaos->{clients}->{$target}->{host} = $host;
		$chaos->{games}->sendMessage (to => $target, message => $message);
		return "Message \"$message\" has been delivered to $target.";
	}
	else {
		return "No host could be found for that listener.";
	}
}
{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Send a plain message to somebody.',
	Usage => '!sayto <username|screenname> <message>',
	Listener => 'All',
};