#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !juppjupp
#    .::   ::.     Description // JuppJupps!
# ..:;;. ' .;;:..        Usage // !juppjupp
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub juppjupp {
	my ($self,$client,$msg,$listener) = @_;

	# Juggernaut version of the JuppJupp Commands. This code was
	# written entirely by Cerone Kirsle, only using simple facts
	# such as probability of capturing a JuppJupp, from the other
	# "official" JuppJupp commands. I do not claim credit for the
	# concept of JuppJupps and only wrote this command on demand,
	# and because I had nothing better I'd rather be doing.

	# If they're in the callback...
	if ($chaos->{_users}->{$client}->{callback} eq "juppjupp") {
		# Get data from the message.
		my ($action,$data) = split(/ /, $msg, 2);
		$action = lc($action);

		my $file = "./clients/juppjupps/$listener\-$client\.txt";

		my ($reply,$event,$count);

		# Go through the actions.
		if ($action eq "scout") {
			$reply = "Scouting the area...\n\n";

			$event = int(rand(2)) + 1;

			if ($event == 1) {
				$reply .= "There! On the horizon! A JuppJupp! You take out your net and run for "
					. "the JuppJupp.\n\n";

				my $catch = int(rand(2)) + 1;

				if ($catch == 1) {
					$reply .= "No! It got away! Oh well... better luck next time!";
				}
				else {
					$reply .= "You caught it! You caught the JuppJupp! Congratulations!";

					# If they have a record already...
					if (-e $file == 1) {
						open (OLD, $file);
						$count = <OLD>;
						close (OLD);

						$count++;

						open (NEW, ">$file");
						print NEW $count;
						close (NEW);
					}
					else {
						open (NEW, ">$file");
						print NEW "1";
						close (NEW);
					}
				}
			}
			else {
				$reply .= "There were no JuppJupps to be found, "
					. "$chaos->{_users}->{$client}->{name}.";
			}

			return $reply;
		}
		elsif ($action eq "count") {
			# Count their JuppJupps.
			if (-e $file == 1) {
				open (COUNT, $file);
				$count = <COUNT>;
				close (COUNT);

				return "You have $count JuppJupps.";
			}
			else {
				return "You don't have any JuppJupps on record. Type \"scout\" to find some!";
			}
		}
		elsif ($action eq "promote") {
			# Become the new JuppJupp Master.
			if (-e $file == 1) {
				open (COUNT, $file);
				$count = <COUNT>;
				close (COUNT);

				# You need 100 JuppJupps to become the master.
				if ($count >= 100) {
					# Remove 100 JuppJupps.
					$count -= 100;
					open (NEW, ">$file");
					print NEW $count;
					close (NEW);

					# Save the new master.
					open (MASTER, ">./clients/juppjupps/_master.txt");
					print MASTER "$listener\-$client";
					close (MASTER);

					return "Congratulations! You're the JuppJupp Master!";
				}
				else {
					return "You don't have enough JuppJupps to be the master! "
						. "You need 100!";
				}
			}
			else {
				return "You don't have a JuppJupp record. Type \"scout\" to find some!";
			}
		}
		elsif ($action eq "master") {
			# See the JuppJupp Master.
			if (-e "./clients/juppjupps/_master.txt" == 1) {
				open (MASTER, "./clients/juppjupps/_master.txt");
				my $master = <MASTER>;
				close (MASTER);

				my ($m_lis,$m_name) = split(/\-/, $master);

				return "The current JuppJupp Master Is:\n\n"
					. "$m_lis User $m_name!";
			}
			else {
				return "There is not yet a JuppJupp master. Catch 100 JuppJupps to "
					. "become the master! :-)";
			}
		}
		elsif ($action eq "free") {
			# Set free a JuppJupp.
			if (-e $file == 1) {
				open (COUNT, $file);
				$count = <COUNT>;
				close (COUNT);

				# They need at least 1 JuppJupp to set free.
				if ($count >= 1) {
					if ($count == 1) {
						$reply = "You released your ONLY friend into the wild!";
					}
					else {
						$reply = "You released your friend into the wild.";
					}

					# Set it free!
					$count--;

					open (NEW, ">$file");
					print NEW $count;
					close (NEW);

					return $reply;
				}
				else {
					return "You don't have any JuppJupps to set free!";
				}
			}
			else {
				return "You don't have a JuppJupp record. Type \"scout\" to catch some!";
			}
		}
		elsif ($action eq "eat") {
			# Eat a JuppJupp.
			if (-e $file == 1) {
				open (COUNT, $file);
				$count = <COUNT>;
				close (COUNT);

				# They need at least 1 JuppJupp to eat.
				if ($count >= 1) {
					# Set it free!
					$count--;

					open (NEW, ">$file");
					print NEW $count;
					close (NEW);

					return "You toss one of your beloved JuppJupps onto a buttered "
						. "frying pan and pop it into your mouth.";
				}
				else {
					return "You don't have any JuppJupps to cook!";
				}
			}
			else {
				return "You don't have a JuppJupp record. Type \"scout\" to catch some!";
			}
		}
		elsif ($action eq "exit") {
			# They're quitting.
			delete $chaos->{_users}->{$client}->{callback};

			return "We're done for now. Come back soon! :-)";
		}
		else {
			return "Valid sub-commands are as follows:\n\n"
				. "scout - Scout for JuppJupps\n"
				. "count - Count your JuppJupps\n"
				. "promote - Become the JuppJupp Master!\n"
				. "master - See the current Master!\n"
				. "free - Set a JuppJupp free!\n"
				. "eat - Eat a JuppJupp!\n\n"
				. "Or type \"exit\" to quit.";
		}
	}
	else {
		# Set the callback.
		$chaos->{_users}->{$client}->{callback} = "juppjupp";

		return "Welcome to JuppJupp World!\n\n"
			. "Sub-Commands:\n"
			. "scout - Scout for JuppJupps!\n"
			. "count - Count how many JuppJupps you have!\n"
			. "promote - Make yourself the JuppJupp Master!\n"
			. "master - See the current Master!\n"
			. "free - Set a JuppJupp free!\n"
			. "eat - Eat a JuppJupp!\n\n"
			. "Or type \"exit\" to quit.";
	}
}

{
	Category => 'Fun & Games',
	Description => 'JuppJupps!',
	Usage => '!juppjupp',
	Listener => 'All',
};