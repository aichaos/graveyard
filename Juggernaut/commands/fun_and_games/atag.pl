#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !atag
#    .::   ::.     Description // The Game of Azulian Tag
# ..:;;. ' .;;:..        Usage // !atag <cmd> [args]
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // AIM,MSN,IRC
#     :     :        Copyright // 2004 Chaos AI Technology

sub atag {
	my ($self,$client,$msg,$listener) = @_;

	# Information about this exact copy of Azulian Tag.
	my $VER = "1.6";

	# This is AIM only (MSN is kinda glitchy for this).
	return "This command is for AIM and MSN only." unless
		($listener eq "AIM" || $listener eq "MSN" || $listener eq "IRC");

	# Get our screenname.
	my $sn;
	$sn = $self->screenname() if $listener eq "AIM";
	$sn = $self->{Msn}->{Handle} if $listener eq "MSN";
	$sn = $self->nick() if $listener eq "IRC";
	$sn = lc($sn);
	$sn =~ s/ //g;

	$listener = lc($listener);

	# They can only play if they're in a callback.
	if (exists $chaos->{_users}->{$client}->{callback}) {
		# Get data from the message.
		my ($type,$data) = split(/ /, $msg, 2);
		$type = lc($type);
		$type =~ s/ //g;

		# Go through the actions.
		if ($type eq "help") {
			# Sub-actions.
			$data = lc($data);
			if ($data eq "about") {
				return "</b>:: About Azulian Tag ::\n\n"
					. "Azulian Tag is the inverted form of typical Tag. In Azulian "
					. "Tag, the player who is \"<b>it</b>\" is the one being hunted "
					. "by the other players. When the \"<b>it</b>\" has been located, "
					. "the finder becomes \"<b>it</b>\" and is then being hunted down "
					. "by the other players.";
			}
			elsif ($data eq "commands") {
				return ":: Commands ::\n\n"
					. "The commands are as follows:\n\n"
					. "help [topic] - Help with the game.\n"
					. "players - Shows the list of players.\n"
					. "tag <lt>username<gt> - Tag a player.\n"
					. "send <lt>msg<gt> - Send a message to all players\n\n"
					. ":: Admin Commands\n"
					. "kill - Terminate the game.\n"
					. "drop <lt>username<gt> - Drop a user from the game.";
			}
			elsif ($data eq "credits") {
				return ":: Credits ::\n\n"
					. "Programmer: Cerone Kirsle";
			}
			else {
				return "</b>:: Azulian Tag Help ::\n\n"
					. "Please type \"<b>help <lt>topic<gt></b>\" for a topic listed "
					. "below.\n"
					. '<gt> ' . "about\n"
					. '<gt> ' . "commands\n"
					. '<gt> ' . "credits\n\n"
					. "Azulian Tag version $VER";
			}
		}
		elsif ($type eq "players") {
			my @players;
			foreach my $player (keys %{$chaos->{_data}->{atag}->{players}}) {
				push @players, $player;
			}
			return ":: Players ::\n\n" . join (", ", @players);
		}
		elsif ($type eq "tag") {
			$data = lc($data);

			return "Specify somebody to tag!" if length $data == 0;

			# If they tagged the right target.
			if ($chaos->{_data}->{atag}->{it} eq $data) {
				&atag_sendmsg ('found',$chaos->{_data}->{atag}->{it});

				# Mark them as "IT" now!
				$chaos->{_data}->{atag}->{it} = $client;

				return "</b>You got the right person! Now YOU are <b>it!</b> :-)";
			}
			else {
				return "Nope, not the one! Keep looking!";
			}
		}
		elsif ($type eq "send") {
			return "I need a message to send." if length $data == 0;

			# Send a message to all players.
			&atag_sendmsg ('msg',$client,$data);

			return "I have broadcasted the message to all players.";
		}
		elsif ($type eq "exit") {
			# Send a message.
			&atag_sendmsg ('exit',$client);

			delete $chaos->{_users}->{$client}->{callback};
			delete $chaos->{_data}->{atag}->{players}->{$client};

			if ($chaos->{_data}->{atag}->{it} eq $client) {
				&atag_newit();
			}

			return "You have left the game.";
		}
		else {
			# The rest are Admin Only.
			if (isAdmin($client,$listener)) {
				if ($type eq "kill") {
					# Kill the game.
					&atag_sendmsg ('kill',$client);

					delete $chaos->{_data}->{atag}->{it};
					delete $chaos->{_data}->{atag};

					delete $chaos->{_users}->{$client}->{callback};
					return "I have killed the game.";
				}
				elsif ($type eq "drop") {
					if (length $data > 0) {
						# Remove this player's data.
						delete $chaos->{_users}->{$data}->{callback};
						delete $chaos->{_data}->{atag}->{players}->{$data};

						&atag_sendmsg ('drop',$data);

						if ($chaos->{_data}->{atag}->{it} eq $data) {
							&atag_newit();
						}

						return "$data has been dropped from the game.";
					}
					else {
						return "You need to provide somebody to drop.";
					}
				}
				else {
					return "Invalid command. Type \"help commands\" for some commands.";
				}
			}
			else {
				return "Invalid command. Type \"help commands\" for some commands.";
			}
		}
	}
	else {
		# Set the Super Callback.
		$chaos->{_users}->{$client}->{callback} = "atag";

		# Add them to the Azulian Tag players list.
		$chaos->{_data}->{atag}->{players}->{$client}->{msg} = uc($listener);
		$chaos->{_data}->{atag}->{players}->{$client}->{host} = $sn;

		# If on MSN, save this socket.
		if (uc($listener) eq "MSN") {
			my $sock = $self->getID;
			$chaos->{_data}->{atag}->{players}->{$client}->{sock} = $sock;
		}

		# If nobody can claim responsibility for being "IT"...
		if (!exists $chaos->{_data}->{atag}->{it}) {
			$chaos->{_data}->{atag}->{it} = $client;
		}

		# Broadcast this.
		&atag_sendmsg ('join',$client);

		# Return.
		return ".: Welcome to Azulian Tag! :.\n\n"
			. "Type \"help\" for some help on the game, or \"exit\" to "
			. "exit the game.";
	}
}
sub atag_sendmsg {
	# Get data from the shift.
	my ($type,$user,$data) = @_;

	# The message types.
	my $reply;
	my $key;
	my @players;
	if ($type eq "join") {
		$reply = ":: Azulian Tag ::\n\n"
			. "$user has joined the game. Updated list of players:\n";
		foreach $key (keys %{$chaos->{_data}->{atag}->{players}}) {
			push @players, $key;
		}
		$reply .= join (", ", @players);
	}
	elsif ($type eq "found") {
		$reply = ":: Azulian Tag ::\n\n"
			. "The victim has been found ($user). Now find out who "
			. "tagged them!";
	}
	elsif ($type eq "msg") {
		$reply = ":: Azulian Tag ::\n\n"
			. "Message from $user: $data";
	}
	elsif ($type eq "kill") {
		$reply = ":: Azulian Tag ::\n\n"
			. "The game has been terminated by administrator $user.";
	}
	elsif ($type eq "drop") {
		$reply = ":: Azulian Tag ::\n\n"
			. "$user has been kicked from the game by an administrator.";
	}
	elsif ($type eq "idle") {
		$reply = ":: Azulian Tag ::\n\n"
			. "$user has been disconnected (idle).";
	}
	elsif ($type eq "exit") {
		$reply = ":: Azulian Tag ::\n\n"
			. "$user has left the game.";
	}
	else {
		return 0;
	}

	# If the "It" is ever removed from the game and not reset...
	my $it = $chaos->{_data}->{atag}->{it};
	&atag_newit () unless exists $chaos->{_data}->{atag}->{players}->{$it};

	# Send a message to all users.
	my ($listener,$host);
	foreach my $key (keys %{$chaos->{_data}->{atag}->{players}}) {
		$listener = $chaos->{_data}->{atag}->{players}->{$key}->{msg};
		$host = $chaos->{_data}->{atag}->{players}->{$key}->{host};

		unless (defined $host && defined $listener) {
			&panic ("Unknown listener and host for $key!", 0);
			next;
		}

		# Update the callbacks.
		if ($type eq "kill") {
			delete $chaos->{_users}->{$key}->{callback};
		}
		else {
			$chaos->{_users}->{$key}->{callback} = "atag";
		}

		# Send a message.
		if ($listener eq "AIM") {
			# The AIM Host.
			my $font = '<body bgcolor="#FFFFFF" link="#0000FF" vlink="#0000FF">'
				. '<font face="Verdana" size="2" color="#FF9900"><b>';
			my $aim_out = $font . $reply . '</b></font></body>';
			$aim_out =~ s/\n/<br>/ig;

			&dosleep (3);
			$chaos->{$host}->{client}->send_im ($key,$aim_out);
		}
		elsif ($listener eq "MSN") {
			# See if the socket still exists.
			my $sock = $chaos->{_data}->{atag}->{players}->{$key}->{sock};
			my $convo = $chaos->{$host}->{client}->getConvo ($sock);

			# Send to this convo.
			if (defined $convo) {
				$convo->sendmsg ($reply,
					Font => 'Verdana',
					Color => '0099FF',
					Style => 'B',
				);
			}
		}
		elsif ($listener eq "IRC") {
			# Send each message individually.
			my @irc_out = split(/\n/, $reply);
			foreach my $irc (@irc_out) {
				$self->privmsg ($key,$irc);
			}
		}
		else {
			&panic ("Unknown host messenger in Azulian Tag.", 0);
		}

		undef $listener;
		undef $host;
	}

	return 1;
}
sub atag_newit {
	# Get a new "IT"!

	print "Azulian Tag // Spawning a new \"IT\"\n\n";

	my @players;
	foreach my $key (keys %{$chaos->{_data}->{atag}->{players}}) {
		push (@players, $key);
	}

	# Pick a new "IT" from the players.
	my $it = $players [ int(rand(scalar(@players))) ];
	$chaos->{_data}->{atag}->{it} = $it;

	return 1;
}

{
	Category => 'Fun & Games',
	Description => 'Azulian Tag',
	Usage => '!atag',
	Listener => 'AIM,MSN,IRC',
};