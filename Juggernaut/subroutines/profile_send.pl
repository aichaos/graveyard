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
#  Subroutine: profile_send
# Description: Set a variable in the user's profile.

sub profile_send {
	# Get variables from the shift.
	my ($client,$listener,$variable,$value) = @_;

	$listener = uc($listener);
	$variable = lc($variable);
	$variable =~ s/ //g;

	$chaos->{_users}->{$client}->{$variable} = $value;

	# See if they have a profile.
	if (-e "./clients/$listener\-$client.txt" == 1) {
		my $final;
		# Open their profile.
		open (PRO, "./clients/$listener\-$client.txt");
		my @data = <PRO>;
		close (PRO);

		chomp @data;

		# Load their profile into the hash.
		my $found = 0;
		foreach my $line (@data) {
			my ($what,$is) = split(/=/, $line, 2);
			$what = lc($what);
			$what =~ s/ //g;

			if ($what eq $variable) {
				$found = 1;
				$final .= "$what=$value\n";
			}
			else {
				$final .= "$what=$is\n";
			}
		}

		# If this variable was not found, add it to the end.
		if ($found == 0) {
			$final .= "$variable=$value\n";
		}

		# Save the new profile.
		open (NEW, ">./clients/$listener\-$client.txt");
		print NEW $final;
		close (NEW);

		$chaos->{_users}->{$client}->{$variable} = $value;
	}
}
1;