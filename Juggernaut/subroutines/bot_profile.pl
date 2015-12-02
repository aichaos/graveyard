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
#  Subroutine: bot_profile
# Description: Loads the bot's profile.

sub bot_profile {
	# Get variables from the shift.
	my $sn = shift;

	# Format the bot's screenname.
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Load the bot's profile.
	if (exists $chaos->{$sn}->{data}) {
		if (-e $chaos->{$sn}->{data} == 1) {
			open (DATA, $chaos->{$sn}->{data});
			my @data = <DATA>;
			close (DATA);

			chomp @data;

			foreach my $line (@data) {
				my ($what,$is) = split(/=/, $line, 2);
				$what = lc($what);
				$what =~ s/ //g;

				$chaos->{$sn}->{data}->{$what} = $is;
			}
		}
	}

	# Return true.
	return 1;
}
1;