#      .   .               <Leviathan>
#     .:...::     Command Name // !socks
#    .::   ::.     Description // Socket controls.
# ..:;;. ' .;;:..        Usage // !socks
#    .  '''  .     Permissions // Administrator Only.
#     :;,:,;:         Listener // MSN
#     :     :        Copyright // 2005 AiChaos Inc.

sub socks {
	my ($self,$client,$msg) = @_;

	# Must be an admin.
	return "This command may only be used by Administrators and higher!" unless &isAdmin($client);
	return "This command is for MSN Messenger only!" unless $client =~ /^MSN\-/i;

	# Get our MSN object.
	my $sn = $self->{Msn}->{Handle};
	$sn = lc($sn);
	$sn =~ s/ //g;
	my $msn = $chaos->{bots}->{$sn}->{client};

	# Sub-commands?
	if (length $msg > 0) {
		my ($command,$sock) = split(/\s+/, $msg, 2);
		$command = lc($command);

		# Two commands: join, and kill.
		if ($command eq "join") {
			# Must be a valid socket.
			if ($sock =~ /[^0-9]/ || not defined $sock) {
				return "Invalid socket: you must give a socket ID when using the \"join\" command:\n\n"
					. "Example: !socks join 12";
			}

			# Does the socket exist?
			my $socks = $msn->getConvoList;
			if (exists $socks->{$sock}) {
				# Invite them to this socket.
				my $convo = $msn->getConvo($sock);
				my $user = $client;
				$user =~ s/^MSN\-//i;

				$convo->invite ($user);
				$convo->sendMessage ("$user has joined us...",
					Font   => 'Courier New',
					Color  => '990099',
					Effect => 'B',
				);

				return "I have tried to invite you to the conversation.";
			}
			else {
				return "That socket doesn't exist! Use \"!socks\" to list the sockets.";
			}
		}
		elsif ($command eq "kill") {
			# Must be a valid socket.
			if ($sock =~ /[^0-9]/ || not defined $sock) {
				return "Invalid socket: you must give a socket ID when using the \"join\" command:\n\n"
					. "Example: !socks join 12";
			}

			# Does the socket exist?
			my $socks = $msn->getConvoList;
			if (exists $socks->{$sock}) {
				# Terminate this socket.
				my $convo = $msn->getConvo($sock);

				# Find the killer's position.
				my $position = 'an Administrator';
				$position = 'my master' if &isMaster($client);

				$convo->sendMessage ("I am leaving this conversation under orders of $position.",
					Font   => 'Courier New',
					Color  => '0000FF',
					Effect => 'B',
				);
				sleep(1);
				$convo->leave;

				return "I am leaving the conversation \"$sock\".";
			}
			else {
				return "That socket doesn't exist! Use \"!socks\" to list the sockets.";
			}
		}
		else {
			return "Invalid sub-command. The commands are:\n\n"
				. "!socks --Lists all open sockets\n"
				. "!socks join <lt>socket<gt> --Join a socket\n"
				. "!socks kill <lt>socket<gt> --Kill a socket";
		}
	}
	else {
		# Just listing the sockets.
		my $socks = $msn->getConvoList();
		my @list = ();

		foreach my $key (keys %{$socks}) {
			my $convo = $msn->getConvo($key);
			my $buddies = $convo->getMembers();
			my $buds = join (", ", keys %{$buddies});
			push (@list, "$key=$buds");
		}

		return "Open Sockets:\n\n"
			. join ("\n", @list) . "\n\n"
			. "To join a socket: !socks join <lt>socket<gt>\n"
			. "To kill a socket: !socks kill <lt>socket<gt>";
	}
}
{
	Restrict    => 'Administrators',
	Category    => 'Administrator Commands',
	Description => 'Socket controls.',
	Usage       => '!socks',
	Listener    => 'MSN',
};