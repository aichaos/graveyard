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
#  Subroutine: isMod
# Description: Sees if the user is a Moderator.

sub isMod {
	# Get variables from the shift.
	my ($client,$listener) = @_;

	$listener = uc($listener);

	# Open the list of admins.
	open (MOD, "./data/authority/moderator.txt") or panic ("Could not find moderator file!", 0);
	my @data = <MOD>;
	close (MOD);

	chomp @data;

	# Initially they're not moderator.
	my $mod = 0;

	# Go through the list.
	foreach my $line (@data) {
		my ($what,$is) = split(/\-/, $line, 2);
		$what = uc($what);
		$what =~ s/ //g;
		$is = lc($is);
		$is =~ s/ //g;

		if ($listener eq $what) {
			if ($client eq $is) {
				$mod = 1;
			}
		}
	}

	# If they're not in the moderators list, check if they're an admin.
	if ($mod == 0) {
		$mod = isAdmin ($client,$listener);
	}

	# Return if they're a mod.
	return $mod;
}
1;