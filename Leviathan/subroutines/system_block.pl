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
#  Subroutine: system_block
# Description: Handles blocking of users.

sub system_block {
	# Information on the block.
	my $client = shift;
	my $multiply = shift || 1;

	# Load this user's profile.
	&profile_get ($client);

	# The block calculating formula is:
	# (Number of block incidents)^2 * 15 minutes.
	my $count = $chaos->{clients}->{$client}->{blocks} || 0;
	$count++;
	&profile_send ($client,'Blocks',$count);

	# Calculate blocked time.
	my $mins = ($count * $count) * 15;
	my $keep = $mins * 60;

	# If there is a multiplyer, multiply this time by it.
	if ($multiply !~ /[^0-9]/) {
		if ($multiply > 1) {
			$mins *= $multiply;
			$keep *= $multiply;
		}
	}

	$keep = time() + $keep;

	# Save this blocked data.
	&profile_send ($client,'Blocked','1');
	&profile_send ($client,'Expire',$keep);
	&profile_send ($client,'ExMins',$mins);

	# Return information.
	return $mins;
}
{
	Type        => 'subroutine',
	Name        => 'system_block',
	Usage       => '$blocked_minutes = &profile_send($client,$multiplier)',
	Description => 'Handles blocking of users.',
	Author      => 'Cerone Kirsle',
	Created     => '9:02 AM 11/21/2004',
	Updated     => '9:02 AM 11/21/2004',
	Version     => '1.0',
};