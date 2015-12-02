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
# Description: Keeps the bot active (main loops)

sub active {
	my $debug = 0;

	# Update online time.
	$chaos->{_system}->{active_loops} = 0 unless exists $chaos->{_system}->{active_loops};
	$chaos->{_system}->{active_loops}++;
	if ($chaos->{_system}->{active_loops} == 5) {
		open (ACTIVE, ">./data/active.dat");
		print ACTIVE time();
		close (ACTIVE);
		$chaos->{_system}->{active_loops} = 0;
	}

	# Loop all the bots.
	foreach my $key (keys %{$chaos}) {
		# If it's a bot...
		next if $key =~ /^HASH/;
		if (exists $chaos->{$key}->{client} && exists $chaos->{$key}->{listener}) {
			$chaos->{$key}->{client}->do_one_loop();
		}
	}

	if (!exists $chaos->{_system}->{waiting}) {
		$chaos->{_system}->{waiting} = 0;
	}

	my $eval;

	# Go through the message queue.
	if ($chaos->{_system}->{waiting} == 0) {
		# If there is a new queue waiting...
		if (defined $chaos->{_system}->{queue}->[0]) {
			print "QUEUE: Receiving next queue...\n" if $debug == 1;
			my $queue = shift @{$chaos->{_system}->{queue}};
			my ($wait,$action) = split(/===/, $queue, 2);

			print "\tWait: $wait\n"
				. "\tAction: $action\n" if $debug == 1;

			# If there's a wait...
			if ($wait > 0) {
				print "QUEUE: A $wait second wait.\n" if $debug == 1;
				# Then wait.
				$chaos->{_system}->{wait_action} = $action;
				$chaos->{_system}->{wait_time} = (time + $wait);
				$chaos->{_system}->{waiting} = 1;
			}
			else {
				print "QUEUE: No wait!\n" if $debug == 1;
				# Do it.
				$eval = eval ($action);
				print "QUEUE: Result: $eval ($@)\n\n" if $debug == 1;
			}
		}
	}
	else {
		# See if the waiting time has expired.
		if (time > $chaos->{_system}->{wait_time}) {
			my $act = $chaos->{_system}->{wait_action};

			print "QUEUE: Wait time over!\n" if $debug == 1;

			# Do it.
			$eval = eval ($act);
			print "QUEUE: Result: $eval ($@)\n\n" if $debug == 1;

			# Erase the wait.
			delete $chaos->{_system}->{wait_time};
			$chaos->{_system}->{waiting} = 0;
		}
	}

	# Here we do some time based stuff, such as temporary block lists.
	foreach $key (keys %{$chaos->{_data}->{blocks}}) {
		$when = $chaos->{_data}->{blocks}->{$key};

		# If this is not an indefinite block.
		if ($when ne "ban") {
			# See if this time has passed.
			if (time > $when) {
				# Unblock this user.
				unlink ("./data/blocks/$key.txt");
				delete $chaos->{_data}->{blocks}->{$key};
				print "CKS // $key\'s block time has expired.\n\n";
			}
		}
	}

	# Every 5 loops, update our last active time.
	$loop--;
	if ($loop == 0) {
		open (TIME, ">./data/active.dat");
		print TIME time();
		close (TIME);

		$loop = 5;
	}
}
1;