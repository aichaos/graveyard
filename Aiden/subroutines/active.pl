# active.pl - Keeps the bot active.

sub active {
	# Loop each bot.
	foreach my $bot (keys %{$aiden->{bots}}) {
		unless (length $bot) {
			delete $aiden->{bots}->{$bot};
			next;
		}

		if ($aiden->{bots}->{$bot}->{listener} eq 'HTTP') {
			&http_request($bot);
			next;
		}

		$aiden->{bots}->{$bot}->{client}->do_one_loop();
	}

	# Unblock users.
	foreach my $client (keys %{$aiden->{clients}}) {
		if (exists $aiden->{clients}->{$client}->{blocked} && $aiden->{clients}->{$client}->{blocked} == 1) {
			if (time() >= $aiden->{clients}->{$client}->{expires}) {
				&userSend ($client,'blocked',0);
				&userSend ($client,'expires',0);
				print &timestamp . "\n"
					. "AidenSYS: $client block time has expired.\n\n";
			}
		}
	}

	# Process event queueus.
	foreach my $id (keys %{$aiden->{queue}}) {
		# If waiting...
		if ($aiden->{queue}->{$id}->{waiting} == 1) {
			# See if the time has passed.
			if (time() >= $aiden->{queue}->{$id}->{waituntil}) {
				$aiden->{queue}->{$id}->{waiting} = 0;
				print "Debug // Queue wait for $id expired!\n\n" if $aiden->{debug};
				next;
			}
		}
		else {
			# Ready to receive the next queue.
			if (scalar @{$aiden->{queue}->{$id}->{line}}) {
				my $next = shift (@{$aiden->{queue}->{$id}->{line}});
				my ($wait,$code) = split(/===/, $next, 2);

				print "Debug // Receiving Next Queue\n"
					. "\tWait: $wait\n"
					. "\tCode: $code\n" if $aiden->{debug};

				# Eval the code.
				my $eval = eval ($code) || $@;
				print "\tEval: $eval\n"
					. "Waiting $wait seconds...\n\n" if $aiden->{debug};

				if ($wait > 0) {
					my $expires = time() + $wait;
					$aiden->{queue}->{$id}->{waiting} = 1;
					$aiden->{queue}->{$id}->{waituntil} = $expires;
				}
			}
		}
	}
}
1;