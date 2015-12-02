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
# Description: Checks for flooding.

sub flood_check {
	# Get variables from the shift.
	my ($client,$msg) = @_;

	my $isFlood = 0;
	my $reply = '';

	# Check how many messages they've sent, every 10 seconds...
	if (!exists $chaos->{clients}->{$client}->{active}) {
		# First time!
		$chaos->{clients}->{$client}->{actv_msgs} = 0;
		$chaos->{clients}->{$client}->{active} = time();
	}

	# If the time has come...
	if (time() - $chaos->{clients}->{$client}->{active} >= 10) {
		# Count their messages.
		my $count = $chaos->{clients}->{$client}->{actv_msgs};

		# If they've sent 10 messages in 10 seconds...
		if ($count >= 7) {
			# Calculate a block time.
			my $flood = ($count - 7);

			# For every 1 message flooded: 5 minutes temporary ban.
			# If the flood limit was doubled, 24 hours.
			# If the flood limit is 3X, 72 hours.
			if ($flood > 0 && $flood < 14) {
				# Block them.
				my $block = &system_block ($client);

				$isFlood = 1;
				$reply = "Flood detected ($count msgs in 10 seconds)! You are being banned for $block minutes.";
			}
			elsif ($flood >= 14 && $flood < 21) {
				# Double the length.
				my $block = &system_block ($client,2);

				$isFlood = 1;
				$reply = "Flood detected ($count msgs in 10 seconds)! You are now banned for $block minutes.";
			}
			elsif ($flood >= 21) {
				# Triple the length.
				my $block = &system_block ($client,5);

				$isFlood = 1;
				$reply = "Flood detected ($count msgs in 10 seconds)! You are now banned for $block minutes. See you later!";
			}
		}

		# Reset the 10-second-counter.
		$chaos->{clients}->{$client}->{actv_msgs} = 0;
		$chaos->{clients}->{$client}->{active} = time();
	}
	else {
		# Add to their count.
		$chaos->{clients}->{$client}->{actv_msgs}++;
	}

	return ($isFlood,$reply);
}
{
	Type        => 'subroutine',
	Name        => 'flood_check',
	Usage       => '($flood,$reply) = &flood_check($client,$msg)',
	Description => 'Checks for flooding.',
	Author      => 'Cerone Kirsle',
	Created     => '4:29 PM 11/20/2004',
	Updated     => '4:29 PM 11/20/2004',
	Version     => '1.0',
};