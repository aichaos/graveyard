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
#  Subroutine: dosleep
# Description: Allows the bot program to sleep safely. :)

my @sleep_queue = ();

sub dosleep {
	# Get the sleep time from the shift.
	my $sleep = shift;

	# If the sleep time is only one second, this sub really isn't needed.
	if ($sleep == 1) {
		sleep (1);
		return 1;
	}

	# Return 0 if the time isn't good.
	return 0 if length $sleep == 0;
	return 0 if $sleep =~ /[^0-9]/;
	return 0 if $sleep <= 0;

	# Save the time of this sleep.
	push (@sleep_queue, $sleep);

	foreach my $queue (@sleep_queue) {
		my $this = shift (@sleep_queue);

		# Go on a looping loop for one second at a time.
		while ($this > 0) {
			# Loop each connection.
			foreach my $bot (%{$chaos}) {
				if (exists $chaos->{$bot}->{client}) {
					$chaos->{$bot}->{client}->do_one_loop();
				}
			}

			# Sleep 1 second.
			sleep(1);

			# Subtract from the sleep time.
			$this--;
		}
	}

	# Return 1.
	return 1;
}
1;