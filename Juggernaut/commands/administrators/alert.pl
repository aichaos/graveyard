#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !alert
#    .::   ::.     Description // Send an MSN Alert
# ..:;;. ' .;;:..        Usage // !alert <message>
#    .  '''  .     Permissions // Admin Only
#     :;,:,;:         Listener // MSN
#     :     :        Copyright // 2004 Chaos AI Technology

sub alert {
	my ($self,$client,$msg,$listener) = @_;

	# This command is Admin-Only.
	if (isAdmin($client,$listener)) {
		if ($listener eq "MSN") {
			# If they're banned...
			if ($chaos->{_users}->{$client}->{_alertflood} >= 10) {
				return "You are currently banned from using this command. You "
					. "will be unbanned after I am restarted.";
			}

			# Get our original name.
			my $handle = $self->{Msn}->{Handle};
			$handle = lc($handle);
			$handle =~ s/ //g;
			my $nick = $chaos->{$handle}->{nick};

			# Make sure this isn't a flood.
			if (exists $chaos->{$handle}->{_alert}) {
				if (time - $chaos->{$handle}->{_alert} < 60) {
					# Reset the flood time.
					$chaos->{$handle}->{_alert} = time();

					# Add to this user's flood count.
					if (exists $chaos->{_users}->{$client}->{_alertflood}) {
						$chaos->{_users}->{$client}->{_alertflood}++;
					}
					else {
						$chaos->{_users}->{$client}->{_alertflood} = 1;
					}

					if ($chaos->{_users}->{$client}->{_alertflood} >= 10) {
						# Log this.
						open (LOG, ">>./logs/_MSN-alert-floods.txt");
						print LOG localtime() . " - $client has flooded past the alert "
							. "limit 10 times in this session.\n\n";
						close (LOG);

						return "You have flooded alerts 10 times in this session. "
							. "You are now banned from using this command for "
							. "the remainder of my online session. Furthermore, "
							. "this event has been logged. That's right, written "
							. "down for the Master to see. Hope he's merciful.";
					}

					return "Alert flood detected. You have flooded "
						. "$chaos->{_users}->{$client}->{_alertflood} times. "
						. "I suggest you cut it out.";
				}
			}

			if (length $msg > 0) {

				# Set our alert.
				my $head;
				$head = '(M)' if isAdmin ($client,$listener);
				$head = '(*)' if isMaster ($client,$listener);
				my $alert = "$head CKS // $msg";

				# Get a reference to the head object.
				my $master = $chaos->{$handle}->{client};

				# Send it to everybody. 536870964
				$master->setName ("$alert");
				sleep(1);
				$master->setStatus ('HDN');
				sleep(1);
				$master->setStatus ('NLN');
				sleep(1);
				$master->setName ($nick);

				# Save this alert.
				open (LOG, ">>./data/alerts.txt");
				print LOG localtime() . " :: $client sent alert: $alert\n\n";
				close (LOG);

				# Save this time (for alert flood protection).
				$chaos->{$handle}->{_alert} = time();

				return "I have sent the alert.\n\n"
					. "Please wait at least 60 seconds before trying to send "
					. "another alert.";
			}
			else {
				return "You must include a message to send as an alert.\n\n"
					. "!alert message";
			}
		}
		else {
			return "This command applies only to MSN.";
		}
	}
	else {
		return "This command is Admin-Only.";
	}
}

{
	Restrict => 'Administrator',
	Category => 'Administrator Commands',
	Description => 'Send an MSN Sign-on Alert',
	Usage => '!alert <message>',
	Listener => 'MSN',
};