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
#  Subroutine: isAdmin
# Description: Sees if the user is an Admin.

sub isAdmin {
	# Get variables from the shift.
	my ($client,$listener) = @_;

	$listener = uc($listener);

	# Open the list of admins.
	open (ADMIN, "./data/authority/admin.txt") or panic ("Could not find admin file!", 0);
	my @data = <ADMIN>;
	close (ADMIN);

	chomp @data;

	# Initially they're not admin.
	my $admin = 0;

	# Go through the list.
	foreach my $line (@data) {
		my ($what,$is) = split(/\-/, $line, 2);
		$what = uc($what);
		$what =~ s/ //g;
		$is = lc($is);
		$is =~ s/ //g;

		if ($listener eq $what) {
			if ($client eq $is) {
				print "Debug // Clients match - Is Admin!\n";
				$admin = 1;
			}
		}
	}

	# If they're not in the admins list, check if they're the master.
	if ($admin == 0) {
		$admin = isMaster ($client,$listener);
	}

	# Return if they're an admin.
	return $admin;
}
1;