#      .   .               <Leviathan>
#     .:...::     Command Name // !probe
#    .::   ::.     Description // Probe a Bot
# ..:;;. ' .;;:..        Usage // !probe <bot username>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub probe {
	my ($self,$client,$msg) = @_;

	# List of steps to execute and look for a result in the response...
	my $steps = {
		1 => [
			"Hello there!",
			"e",
		],
		2 => [
			"quit",
			"e",
		],
		3 => [
			"!juggernaut",
			"Author: Cerone Kirsle",
		],
		4 => [
			"!copyright",
			"Author: Cerone Kirsle",
		],
		5 => [
			"!status",
			"Juggernaut Version",
		],
		6 => [
			"!stats",
			"Leviathan Version",
		],
		7 => [
			"what is aichaos",
			"aichaos",
		],
	};

	# See if the target is valid.
	if (&isMaster($client)) {
		if (length $msg > 0) {
			my $target = $msg;
			$target = lc($target);
			$target =~ s/ //g;
			my $host = undef;
			($target,$host) = split(/\s+/, $msg, 2);
			$host = lc($host);
			$host =~ s/ //g;
			my ($lis,$nick) = split(/\-/, $target, 2);
			$lis = uc($lis);
			return "Invalidly formatted username." unless length $nick > 0;
			$target = join ('-', $lis, $nick);

			# Target can't be blocked.
			my ($blocked,$r) = &isBlocked($target);
			if ($blocked) {
				return "The target is blocked; you must unblock the target for interrogation.";
			}

			# Investigate the user.
			$chaos->{clients}->{$target}->{callback} = 'probe';
			$chaos->{clients}->{$target}->{failsafe} = 1; # Failsafe will block the user automatically
									# if they escape this callback.

			# Go after the user.
			if (defined $host && exists $chaos->{bots}->{$host}) {
				# Skip.
			}
			else {
				foreach my $bot (keys %{$chaos->{bots}}) {
					my $l = $chaos->{bots}->{$bot}->{listener};
					$l = uc($l);
					if ($l eq $lis) {
						$host = $bot;
					}
				}
			}

			if (defined $host) {
				# Begin the interrogation.
				$chaos->{clients}->{$target}->{host} = $host;
				$chaos->{clients}->{$target}->{_step} = 1;
				$chaos->{clients}->{$target}->{probe} = $client;
				$chaos->{games}->sendMessage (to => $target,message => $steps->{1}->[0]);
				return "The target $target has been interrogated ($steps->{1}->[0]) by "
					. "$chaos->{clients}->{$target}->{host}. Results will be returned shortly.";
			}

			return "A host could not be found for the messenger $lis.";
		}
	}
	else {
		# Only allow if there's the callback.
		if ($chaos->{clients}->{$client}->{callback} eq 'probe') {
			# Steps.
			my $step = $chaos->{clients}->{$client}->{_step} || 1;
			if (exists $steps->{$step}) {
				my $trigger = $steps->{$step}->[0];
				my $reply = $steps->{$step}->[1];

				if ($msg =~ /$reply/i) {
					$chaos->{clients}->{$client}->{_logs}->{$step} = 1;
				}
				else {
					$chaos->{clients}->{$client}->{_logs}->{$step} = 0;
				}

				# Up the steps.
				$chaos->{clients}->{$client}->{_step}++;
				if (exists $steps->{$chaos->{clients}->{$client}->{_step}}) {
					return $steps->{$chaos->{clients}->{$client}->{_step}}->[0];
				}
				else {
					# Return to prober.
					my $probe = $chaos->{clients}->{$client}->{probe};
					$chaos->{clients}->{$probe}->{host} = $chaos->{clients}->{$client}->{host};

					# Gather the results.
					my @results = ();
					my $perfect = 1;
					foreach (my $i = 1; exists $steps->{$i}; $i++) {
						my $trigger = $steps->{$i}->[0];
						my $reply   = $steps->{$i}->[1];
						my $text = "$i: $trigger - Look for \"$reply\":\n";
						if ($chaos->{clients}->{$client}->{_logs}->{$i} == 1) {
							$text .= "Test passed.\n\n";
						}
						else {
							$perfect = 0;
							$text .= "FAILED!\n\n";
						}
						push (@results, $text);
					}
					my $result = "Probe Results:\n\n"
						. join ("\n", @results);
					if ($perfect == 0) {
						$result .= "You may want to investigate this bot yourself.";
					}

					$chaos->{games}->sendMessage (to => $probe,message => $result);
					delete $chaos->{clients}->{$client}->{callback};
					return '<noreply>';
				}
			}
			else {
				return 'Error!';
			}
		}
		else {
			return "Access Denied.";
		}
	}
}
{
	Hidden => 1,
	Category => 'General',
	Description => 'Probe a Bot',
	Usage => '!probe <bot username>',
	Listener => 'All',
};
