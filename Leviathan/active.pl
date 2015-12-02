#              ::.                   .:.
#               .;;:  ..:::::::.  .,;:
#                 ii;,,::.....::,;;i:
#               .,;ii:          :ii;;:
#             .;, ,iii.         iii: .;,
#            ,;   ;iii.         iii;   :;.
# .         ,,   ,iii,          ;iii;   ,;
#  ::       i  :;iii;     ;.    .;iii;.  ,,      .:;
#   .,;,,,,;iiiiii;:     ,ii:     :;iiii;;i:::,,;:
#     .:,;iii;;;,.      ;iiii:      :,;iiiiii;,:
#          :;        .:,,:..:,,.        .:;..
#           i.                  .        ,:
#           :;.         ..:...          ,;
#            ,;.    .,;iiiiiiii;:.     ,,
#             .;,  :iiiii;;;;iiiii,  :;:
#                ,iii,:        .,ii;;.
#                ,ii,,,,:::::::,,,;i;
#                ;;.   ...:.:..    ;i
#                ;:                :;
#                .:                ..
#                 ,                :
#  Subroutine: active
# Description: Called on a loop; keeps the bots active.

sub active {
	# Step 1: Update Online Time.
	$chaos->{system}->{active_loops} = 0 unless exists $chaos->{system}->{active_loops};
	$chaos->{system}->{active_loops}++;
	if ($chaos->{system}->{active_loops} >= 10) {
		open (ACTIVE, ">./data/local/active.dat");
		print ACTIVE time();
		close (ACTIVE);
		$chaos->{system}->{active_loops} = 0;
	}

	# Step 2: Loop the bots.
	foreach my $bot (keys %{$chaos->{bots}}) {
		# Loop it!
		next unless exists $chaos->{bots}->{$bot}->{client};
		if ($chaos->{bots}->{$bot}->{listener} =~ /(aim|msn|irc|toc|yahoo|cyan)/i) {
			$chaos->{bots}->{$bot}->{client}->do_one_loop();
		}
		elsif ($chaos->{bots}->{$bot}->{listener} =~ /^jabber$/i) {
			$chaos->{bots}->{$bot}->{client}->Process (0);
		}
		elsif ($chaos->{bots}->{$bot}->{listener} =~ /^http$/i) {
			&http_receive ($bot);
		}
		elsif ($chaos->{bots}->{$bot}->{listener} =~ /^smtp$/i) {
			&smtp_receive ($bot);
		}
		else {
			&panic ("ACTIVE(): Could not determine listener for $bot!",1);
		}
	}

	# Step 3: Go through the message queues.
	my $eval;
	foreach my $key (keys %{$chaos->{system}->{queue}}) {
		$chaos->{system}->{queue}->{$key}->{waiting} = 0 unless exists $chaos->{system}->{queue}->{$key}->{waiting};

		# See if there are any outbound queues that have expired...
		if ($chaos->{system}->{queue}->{$key}->{waiting} == 1) {
			# See if the time has passed.
			if (time() > $chaos->{system}->{queue}->{$key}->{wait_time}) {
				my $act = $chaos->{system}->{queue}->{$key}->{wait_action};

				print "QUEUE: Wait time over!\n" if $chaos->{debug} == 1;

				# Do it.
				$eval = eval ($act);
				print "QUEUE: Result: $eval ($@)\n\n" if $chaos->{debug} == 1;

				# Erase this data.
				delete $chaos->{system}->{queue}->{$key}->{wait_action};
				delete $chaos->{system}->{queue}->{$key}->{wait_time};
				$chaos->{system}->{queue}->{$key}->{waiting} = 0;
			}
		}
		else {
			if (defined $chaos->{system}->{queue}->{$key}->{line}->[0]) {
				print "QUEUE: Receiving next queue...\n" if $chaos->{debug} == 1;
				my $queue = shift @{$chaos->{system}->{queue}->{$key}->{line}};
				my ($wait,$action) = split(/===/, $queue, 2);

				print "\tWait: $wait\n"
					. "\tAction: $action\n" if $chaos->{debug} == 1;

				# If this queue requires waiting...
				if ($wait > 0) {
					print "QUEUE: A $wait second wait.\n" if $chaos->{debug} == 1;

					# Then wait.
					$chaos->{system}->{queue}->{$key}->{wait_action} = $action;
					$chaos->{system}->{queue}->{$key}->{wait_time} = time() + $wait;
					$chaos->{system}->{queue}->{$key}->{waiting} = 1;
				}
				else {
					print "QUEUE: No wait!\n" if $chaos->{debug} == 1;

					# Do it.
					$eval = eval ($action);
					print "QUEUE: Result: $eval ($@)\n\n" if $chaos->{debug} == 1;
				}
			}
		}
	}

	# Step 4: Handle temporary blocks, and other time-based things.
	foreach my $user (keys %{$chaos->{clients}}) {
		if ($chaos->{clients}->{$user}->{blocked} == 1) {
			my $expire = $chaos->{clients}->{$user}->{expire};
			if (time() > $expire) {
				# Block time expired.
				my $stamp = &get_timestamp();
				print "$stamp\n"
					. "$user\'s temporary block time has expired!\n\n";

				&profile_send ($user,"blocked",0);
				&profile_send ($user,"expire",0);
			}
		}
	}
}
{
	Type        => 'subroutine',
	Name        => 'active',
	Usage       => '&active()',
	Description => 'Called every loop; keeps the bot active.',
	Author      => 'Cerone Kirsle',
	Created     => '1:58 PM 11/20/2004',
	Updated     => '4:03 PM 2/2/2005',
	Version     => '1.1',
};