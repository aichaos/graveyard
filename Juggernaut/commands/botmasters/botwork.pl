#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !botwork
#    .::   ::.     Description // Update your bot's BotWork listing.
# ..:;;. ' .;;:..        Usage // !botwork <variable> <value>
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // AIM, MSN
#     :     :        Copyright // 2004 Chaos AI Technology

sub botwork {
	my ($self,$client,$msg,$listener) = @_;

	return "This command is Master Only." if isMaster($client,$listener) == 0;
	my $key;

	# This is for AIM and MSN only.
	if ($listener ne "AIM" && $listener ne "MSN") {
		return "This command is for AIM and MSN only.";
	}

	# Our BotWork Screennames.
	my %bots = (
		aim => 'BotWorkWatcher',
		msn => 'botlist@botwork.com',
	);

	# Get OUR username.
	my $sn;
	$sn = $self->{Msn}->{Handle} if $listener eq "MSN";
	$sn = $self->screenname() if $listener eq "AIM";
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Make sure this is a valid variable.
	my @vars = (
		"name",
		"developer",
		"version",
		"title",
		"description",
		"website",
		"category",
		"template",
		"language",
		"commands",
	);

	# See if the message exists.
	if (length $msg > 0) {
		if ($msg eq "add") {
			# Add the bot.
			if ($listener eq "AIM") {
				&dosleep(3);
				$self->send_im ($bots{aim}, "add $sn");
				return "I have attempted to IM $bots{aim} to be added to the list.";
			}
			elsif ($listener eq "MSN") {
				$chaos->{$sn}->{client}->call ($bots{msn}, "add $sn");
				return "I have attempted to call $bots{msn} to be added to the list.";
			}
			else {
				return "This is a strange error...";
			}
		}
		elsif ($msg eq "remove") {
			# Remove the bot.
			if ($listener eq "AIM") {
				&dosleep(3);
				$self->send_im ($bots{aim}, "remove $sn");
				return "I have attempted to IM $bots{aim} to be removed from the list.";
			}
			elsif ($listener eq "MSN") {
				$chaos->{$sn}->{client}->call ($bots{msn}, "remove $sn");
				return "I have attempted to call $bots{msn} to be removed from the list.";
			}
			else {
				return "This is a strange error...";
			}
		}
		elsif ($msg eq "commands") {
			# Add all commands.

			# This could be a while... pop into maintenance mode!
			$chaos->{_system}->{maintain}->{msg} = "Sending commands to BotWork Watchers...";
			$chaos->{_system}->{maintain}->{on} = 1;
			foreach $key (keys %{$chaos}) {
				if (exists $chaos->{$key}->{client}) {
					# MSN bots, update their name.
					if ($chaos->{$key}->{listener} eq "msn") {
						$chaos->{$key}->{client}->setName ($chaos->{$key}->{nick} . " (Maintenance Mode)");
					}
					# AIM bots, set an away message.
					elsif ($chaos->{$key}->{listener} eq "aim") {
						$chaos->{$key}->{client}->set_away ('<body bgcolor="#000000" link="#FF0000"><font face="Verdana" size="2" color="#FFFF00"><b>' . $chaos->{_system}->{maintain}->{msg} . '</b></font></body>');
					}
					else {
						# Meh, we'll ignore this.
					}
				}
			}

			# Listeners...
			if ($listener eq "AIM") {
				sleep (3);
				$self->send_im ($client,"<body bgcolor=\"#FFFFFF\"><font face=\"Verdana\" size=\"2\" "
					. "color=\"#FF0000\"><b>Sending commands to BotWork Watchers... Please hold.</b>"
					. "</font></body>");
			}
			elsif ($listener eq "MSN") {
				$self->sendmsg ("Sending commands to BotWork Watchers... Please hold.",
					Font => "Verdana",
					Color => "0000FF",
					Style => "B",
				);
			}
			elsif ($listener eq "IRC") {
				$self->privmsg ($client, "Sending commands to BotWork Watchers... Please hold.");
			}

			# Send the messages!
			foreach my $cmd (keys %{$chaos->{_system}->{commands}}) {
				# Next on hidden commands.
				next if $chaos->{_system}->{commands}->{$cmd}->{Hidden} == 1;
				next if length $chaos->{_system}->{commands}->{$cmd}->{Restrict} > 0;

				print "Sending command $chaos->{_system}->{config}->{commandchar}" . "$cmd...\n";

				# Send a message!
				if ($listener eq "AIM") {
					&dosleep (10);
					$self->send_im ($bots{aim}, "!addcommand $chaos->{_system}->{config}->{commandchar}" . "$cmd" . '->' . "$chaos->{_system}->{commands}->{$cmd}->{Description}");
				}
				elsif ($listener eq "MSN") {
					&dosleep (4);
					$chaos->{$sn}->{client}->call ($bots{msn}, "!addcommand  $chaos->{_system}->{config}->{commandchar}" . "$cmd" . '->' . "$chaos->{_system}->{commands}->{$cmd}->{Description}");
				}
			}

			# Turn off maintenance mode.
			delete $chaos->{_system}->{maintain};
			foreach $key (keys %{$chaos}) {
				if (exists $chaos->{$key}->{client}) {
					# MSN bots, update their name.
					if ($chaos->{$key}->{listener} eq "msn") {
						$chaos->{$key}->{client}->setName ($chaos->{$key}->{nick});
					}
					# AIM bots, set an away message.
					elsif ($chaos->{$key}->{listener} eq "aim") {
						$chaos->{$key}->{client}->set_away ('');
					}
					else {
						# Meh, we'll ignore this.
					}
				}
			}

			return "All commands have been broadcasted.";
		}
		else {
			my ($type,$text) = split(/ /, $msg, 2);
			$type = lc($type);
			$type =~ s/ //g;

			# A give-in is the template used.
			$text = "Juggernaut" if $type eq "template";
			# And the language.
			$text = "Perl" if $type eq "language";

			foreach my $var (@vars) {
				if ($type eq $var) {
					# This is a valid variable.
					if ($listener eq "AIM") {
						&dosleep(5);
						$self->send_im ($bots{aim}, "$type=$text");
					}
					elsif ($listener eq "MSN") {
						$chaos->{$sn}->{client}->call ($bots{msn}, "$type=$text");
					}
					else {
						return "This is a strange error.";
					}

					return "I have sent the message.\n\n$type=$text";
				}
			}

			return "That is not a valid variable. Variables are:\n\n"
				. "name [bot name]\n"
				. "developer [your name]\n"
				. "version [bot version]\n"
				. "title [bot title]\n"
				. "description [bot description]\n"
				. "website [website url]\n"
				. "category [Chat|Reference|Games|All purpose]\n"
				. "template Juggernaut\n"
				. "language Perl\n\n"
				. "Don't include the brackets in your messages though. :-P";
		}
	}
	else {
		return "You must specify a message to send.\n\n"
			. "add\n"
			. "remove\n\n"
			. "name [bot name]\n"
			. "developer [your name]\n"
			. "version [bot version]\n"
			. "title [bot title]\n"
			. "description [bot description]\n"
			. "website [website url]\n"
			. "category [Chat|Reference|Games|All purpose]\n"
			. "template Juggernaut\n"
			. "language Perl\n"
			. "commands\n\n"
			. "Don't include the brackets in your messages though. :-P";
	}
}

{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Update your BotWork Listing',
	Usage => '!botwork <variable> <value>',
	Listener => 'AIM/MSN',
};