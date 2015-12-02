#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !maintain
#    .::   ::.     Description // Toggle Bot Maintenance
# ..:;;. ' .;;:..        Usage // !maintain <on|off|set> [message]
#    .  '''  .     Permissions // Admin Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub maintain {
	my ($self,$client,$msg,$listener) = @_;

	# This command is Admin Only.
	if (isAdmin($client,$listener)) {
		# If there's not a maintenance message, set one.
		if (!exists $chaos->{_system}->{maintain}->{msg}) {
			$chaos->{_system}->{maintain}->{msg} = "The bot is currently "
				. "under maintenance mode.";
		}

		# Get the message data.
		my ($command,$option) = split(/\s+/, $msg, 2);
		$command = lc($command);
		my $key;

		# Turning on maintenance mode...
		if ($command eq "on") {
			# See if it's not already on.
			if ($chaos->{_system}->{maintain}->{on} == 1) {
				return "Maintenance mode is already turned on.";
			}
			else {
				# Update each bot's status.
				foreach $key (keys %{$chaos}) {
					if (exists $chaos->{$key}->{client}) {
						# MSN bots, update their name.
						if ($chaos->{$key}->{listener} eq "msn") {
							$chaos->{$key}->{client}->set_name ($chaos->{$key}->{nick} . " (Maintenance Mode)");
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

				$chaos->{_system}->{maintain}->{on} = 1;
				return "Maintenace mode is now on.";
			}
		}
		elsif ($command eq "off") {
			# Turn off maintenance mode.
			if ($chaos->{_system}->{maintain}->{on} != 1) {
				return "Maintenance mode is not currently on.";
			}
			else {
				# Update each bot's status.
				foreach $key (keys %{$chaos}) {
					if (exists $chaos->{$key}->{client}) {
						# MSN bots, reset your nickname.
						if ($chaos->{$key}->{listener} eq "msn") {
							$chaos->{$key}->{client}->set_name ($chaos->{$key}->{nick});
						}
						# AIM bots, return from away.
						elsif ($chaos->{$key}->{listener} eq "aim") {
							$chaos->{$key}->{client}->set_away ("");
						}
						else {
							# Meh, we'll ignore this.
						}
					}
				}

				$chaos->{_system}->{maintain}->{on} = 0;
				return "Maintenance mode has been closed.";
			}
		}
		elsif ($command eq "set") {
			# Set the maintenance message.
			if (length $option > 0 && length $option <= 1024) {
				$chaos->{_system}->{maintain}->{msg} = $option;
				return "I have updated the maintenance message.\n\n$option";
			}
			else {
				return "The message you are trying to set is either too large or "
					. "to small. The limit is between 0 and 1024 characters.\n\n"
					. "!maintain set <lt>new message<gt>";
			}
		}
		elsif ($command eq "get") {
			# Get the current message.
			return "The current message is as follows:\n\n$chaos->{_system}->{maintain}->{msg}";
		}
		else {
			return "Invalid sub-command. Valid subcommands are:\n\n"
				. "!maintain on -- Turn on maintenance\n"
				. "!maintain off -- Turn off maintenance\n"
				. "!maintain get -- Get current message\n"
				. "!maintain set <lt>msg<gt> -- Set a different message";
		}
	}
	else {
		return "This command is Admin Only.";
	}
}

{
	Restrict => 'Administrator',
	Category => 'Administrator Commands',
	Description => 'Maintenance Mode',
	Usage => '!maintain <on|off|set> [message]',
	Listener => 'All',
};