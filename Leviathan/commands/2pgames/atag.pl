#      .   .               <Leviathan>
#     .:...::     Command Name // !atag
#    .::   ::.     Description // Azulian Tag.
# ..:;;. ' .;;:..        Usage // !atag
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub atag {
	my ($self,$client,$msg) = @_;

	my ($listener,$nick) = split(/\-/, $client, 2);

	unless ($listener =~ /(AIM|MSN|IRC|YAHOO|JABBER)/i) {
		return "This game is for instant messengers only. Sorry!";
	}

	# Get us.
	my $sn;
	$sn = $self->screenname() if $listener eq 'AIM';
	$sn = $self->{Msn}->{Handle} if $listener eq 'MSN';
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Create the Azulian Tag game if it doesn't exist yet.
	my $exists = $chaos->{games}->queryGame ('atag');
	if ($exists != 1) {
		$chaos->{games}->create (
			id   => 'atag',
			name => 'Azulian Tag',
		);
	}

	# Set the callback.
	$chaos->{clients}->{$client}->{callback} = 'atag';

	# If they're in the game...
	my $in = $chaos->{games}->queryPlayer ('atag',$client);
	print "In Game: $in\n";
	if ($in == 1) {
		# See if they're using a sub-command.
		if ($msg =~ /^help/i) {
			return ":: Azulian Tag Help ::\n\n"
				. "Please type one of the keywords below for help on that subject:\n\n"
				. "commands - See all Azulian Tag commands\n"
				. "about - About Azulian Tag";
		}
		elsif ($msg =~ /^about/i) {
			return ":: About Azulian Tag ::\n\n"
				. "Azulian Tag is the inverse of traditional tag. The one who is \"it\" "
				. "is being hunted down by the other players. All I can provide you for "
				. "this game is the list of players, you must find out which one is \"it\".";
		}
		elsif ($msg =~ /^commands/i) {
			return ":: Commands List ::\n\n"
				. "help - Shows the Help Menu\n"
				. "tag <lt>username<gt> - Try and tag a user\n"
				. "say <lt>message<gt> - Broadcast a message to all players\n"
				. "exit - Quit the game\n\n"
				. ":: Moderator Functions ::\n"
				. "kick <lt>username<gt> - Kick a user\n"
				. "kill - Terminate the Game";
		}
		elsif ($msg =~ /^kick (.*?)$/i) {
			my $user = $1;
			if (&isMod($client)) {
				# Kick the user.
				$chaos->{games}->broadcast ('atag', ":: Azulian Tag ::\n\n$user has been kicked from the game.");
				$chaos->{games}->dropPlayer ('atag', $user);
				if ($chaos->{data}->{atag}->{it} eq $user) {
					my @players = $chaos->{games}->listPlayers ('atag');
					$chaos->{data}->{atag}->{it} = $players [ int(rand(scalar(@players))) ];
				}
				return '<noreply>';
			}
			else {
				return "You do not have permission to kick users.";
			}
		}
		elsif ($msg =~ /^kill/i) {
			if (&isMod($client)) {
				# Terminate the game.
				my @players = $chaos->{games}->listPlayers ('atag');
				foreach my $item (@players) {
					delete $chaos->{clients}->{$item}->{callback};
				}

				$chaos->{games}->destroy (
					id      => 'atag',
					force   => 1,
					alert   => 1,
					message => "Azulian Tag has been terminated by a moderator.",
				);
				return '<noreply>';
			}
			else {
				return "You do not have permission to terminate this game.";
			}
		}
		elsif ($msg =~ /^say (.*?)$/i) {
			my $say = $1;

			# Send this message.
			$chaos->{games}->broadcast ('atag', ":: Azulian Tag ::\n\n[$client] $say");
			return '<noreply>';
		}
		elsif ($msg =~ /^players$/i) {
			# Get the players.
			my @players = $chaos->{games}->listPlayers ('atag');
			return ":: Players List ::\n\n"
				. join (", ", @players);
		}
		elsif ($msg =~ /^exit$/i) {
			# Exit them.
			$chaos->{games}->broadcast ('atag', ":: Azulian Tag ::\n\n$client has left the game.");
			$chaos->{games}->dropPlayer ('atag', $client);
			if ($chaos->{data}->{atag}->{it} eq $client) {
				my @players = $chaos->{games}->listPlayers ('atag');
				$chaos->{data}->{atag}->{it} = $players [ int(rand(scalar(@players))) ];
			}
			delete $chaos->{clients}->{$client}->{callback};
			return '<noreply>';
		}
		elsif ($msg =~ /^tag (.*?)$/i) {
			# Tag them?
			my $tag = $1;

			# If they were it...
			if ($chaos->{data}->{atag}->{it} eq $tag) {
				$chaos->{games}->broadcast ('atag', ":: Azulian Tag ::\n\n"
					. "The \"it\" has been found (was $tag). Now find out who tagged him!");
				$chaos->{data}->{atag}->{it} = $client;
				return '<noreply>';
			}
			else {
				return "Nope, not the one - keep searching!";
			}
		}
		else {
			return ":: Azulian Tag::\n\n"
				. "Invalid command, type \"help\" for more information.";
		}
	}
	else {
		# If there is no "it"
		if (!exists $chaos->{data}->{atag}->{it}) {
			$chaos->{data}->{atag}->{it} = $client;
		}

		# Add them.
		$chaos->{games}->broadcast ('atag', ":: Azulian Tag ::\n\n$client has joined the game.");
		$chaos->{games}->addPlayer ('atag',
			name => $client,
		);

		return "Welcome to Azulian Tag! Type \"help\" for some help, or type \"players\" to see who's playing now!";
	}
}
{
	Category => 'Multiplayer Games',
	Description => 'Azulian Tag.',
	Usage => '!atag',
	Listener => 'All',
};
