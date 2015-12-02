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
#  Subroutine: flood_check
# Description: Checks for rate limit floods.

sub flood_check {
	# Get variables from the shift.
	my ($client,$listener,$msg) = @_;

	my $isFlood = 0;
	my $reply = '';

	# Check how many messages they've sent, every 10 seconds...
	if (length $chaos->{_users}->{$client}->{active} == 0) {
		# First time!
		$chaos->{_users}->{$client}->{actv_msgs} = 0;
		$chaos->{_users}->{$client}->{active} = time();
	}

	# If the time has come...
	if (time - $chaos->{_users}->{$client}->{active} >= 10) {
		# Count their messages.
		my $count = $chaos->{_users}->{$client}->{actv_msgs};

		# If they've sent 10 messages in 10 seconds...
		if ($count >= 7) {
			# Calculate a block time.
			my $flood = ($count - 7);

			# For every 1 message flooded: 5 minutes temporary ban.
			# If the flood limit was doubled, 24 hours.
			# If the flood limit is 3X, 72 hours.
			if ($flood > 0 && $flood < 14) {
				my $min_block = (60 * ($flood * 5));

				# Block them.
				$chaos->{_data}->{blocks}->{"$listener\-$client"} = (time + $min_block);

				$isFlood = 1;
				$reply = "Flood detected ($flood msgs in 10 seconds)! You are being banned for $min_block seconds.";
			}
			elsif ($flood >= 14 && $flood < 21) {
				# 24-hour block.
				&system_block ($client,$listener,'24',0);

				$isFlood = 1;
				$reply = "Flood detected ($flood msgs in 10 seconds)! You are now banned for 24 hours. See you tomorrow!";
			}
			elsif ($flood >= 21) {
				# Permanent ban.
				&system_block ($client,$listener,'72',0);

				$isFlood = 1;
				$reply = "Flood detected ($flood msgs in 10 seconds)! You are now banned for 72 hours (3 days). See you later!";
			}
		}

		# Reset the 10-second-counter.
		$chaos->{_users}->{$client}->{actv_msgs} = 0;
		$chaos->{_users}->{$client}->{active} = time();
	}
	else {
		# Add to their count.
		$chaos->{_users}->{$client}->{actv_msgs}++;
	}

	return ($isFlood,$reply);
}
1;