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
#  Subroutine: time_offset
# Description: Get the time offset for a given time zone code.

sub time_offset {
	# Get the time zone from the shift.
	my $zone = shift;

	# The Time Zones.
	my %zones = (
		GMT => 0,
		NST => -3.5,
		NDT => -2.5,
		AST => -4,
		ADT => -3,
		EST => -5,
		EDT => -4,
		CST => -6,
		CDT => -5,
		MST => -7,
		MDT => -6,
		PST => -8,
		PDT => -7,
		AKST => -9,
		AKDT => -8,
		HAST => -10,
		HADT => -9,
	);

	if (exists $zones{$zone}) {
		return $zones{$zone};
	}
	else {
		return 0;
	}
}
1;