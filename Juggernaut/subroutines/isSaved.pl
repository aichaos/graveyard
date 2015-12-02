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
#  Subroutine: isSaved
# Description: Checks if the user is on the White List.

sub isSaved {
	# Get variables from the shift.
	my ($client,$listener) = @_;

	# Initially, they're not safe.
	my $safe = 0;

	# See if the White List exists.
	if (-e "./data/whitelist.txt" == 1) {
		# If the whitelist exists, open it.
		open (LIST, "./data/whitelist.txt");
		my @list = <LIST>;
		close (LIST);

		chomp @list;

		# Go through each item on the list.
		foreach my $item (@list) {
			my ($wl,$wc) = split(/\-/, $item, 2);
			$wl = uc($wl);
			$wl =~ s/ //g;
			$wc = lc($wc);
			$wc =~ s/ //g;

			# If they're safe.
			if ($wl eq $listener && $wc eq $client) {
				$safe = 1;
			}
		}
	}

	# Return if they're safe or not.
	return $safe;
}
1;