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
#  Subroutine: point_manager
# Description: Manages the bot's points system.

sub point_manager {
	# Get variables from the shift.
	my ($client,$listener,$type,$value) = @_;

	# Get the user's profile.
	&profile_get ($client,$listener);

	# Type: Addition.
	if ($type eq '+') {
		$chaos->{_users}->{$client}->{points} = $chaos->{_users}->{$client}->{points} + $value;
	}
	# Type: Subtraction.
	elsif ($type eq '-') {
		$chaos->{_users}->{$client}->{points} = $chaos->{_users}->{$client}->{points} - $value;
	}
	# Type: Equals.
	elsif ($type eq '=') {
		$chaos->{_users}->{$client}->{points} = $value;
	}
	else {
		return 0;
	}

	# Save the new points count.
	my $points = $chaos->{_users}->{$client}->{points};
	&profile_send ($client,$listener,"points",$chaos->{_users}->{$client}->{points});

	# Return true.
	return 1;
}
1;