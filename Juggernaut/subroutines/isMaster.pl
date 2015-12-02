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
#  Subroutine: isMaster
# Description: Sees if the user is the Master.

sub isMaster {
	# Get variables from the shift.
	my ($client,$listener) = @_;

	$listener = uc($listener);

	# Open the list of masters.
	open (MASTER, "./data/authority/master.txt");
	my @data = <MASTER>;
	close (MASTER);

	chomp @data;

	# Initially they're not master.
	my $master = 0;

	# Go through the list.
	foreach my $line (@data) {
		my ($what,$is) = split(/\-/, $line, 2);
		$what = uc($what);
		$what =~ s/ //g;
		$is = lc($is);
		$is =~ s/ //g;

		if ($listener eq $what) {
			if ($client eq $is) {
				$master = 1;
			}
		}
	}

	# Return if they're a master.
	return $master;
}
1;