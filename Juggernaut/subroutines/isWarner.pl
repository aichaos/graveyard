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
#  Subroutine: isWarner
# Description: Sees if the user is on the warners list (applies to AIM only).

sub isWarner {
	# Get variables from the shift.
	my ($aim,$client,$listener) = @_;
	$safe = shift;

	$safe = 0 unless $safe == 1;

	# Initially, they're not a warner.
	my $warner = 0;

	# Make sure we're talking about an AIM user here. MSN doesn't have warnings. :P
	if ($listener eq "AIM") {
		# See that the warners list exists.
		if (-e "./data/warners.txt" == 1) {
			# Open the warners list.
			open (LIST, "./data/warners.txt");
			my @list = <LIST>;
			close (LIST);

			chomp @list;

			# Go through each item.
			foreach my $idiot (@list) {
				$idiot = lc($idiot);
				$idiot =~ s/ //g;

				# If they compare...
				if ($client eq $idiot) {
					# They're a warner all right!
					$warner = 1;

					# Warn and block them.
					if ($safe == 0) {
						$aim->evil ($client, 0);
						$aim->add_deny ($client);
						print "CKS // I have attacked that idiot warner $client.\n\n";
					}
				}
			}
		}
	}

	# Return whether or not they're a warner.
	return $warner;
}
1;