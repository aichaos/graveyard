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
#  Subroutine: profile_get
# Description: Loads or creates the user's profile.

sub profile_get {
	# Get variables from the shift.
	my ($client,$listener) = @_;

	# Only load if it hasn't been loaded yet.
	return if exists $chaos->{_users}->{$client};

	$listener = uc($listener);

	# See if they have a profile.
	if (-e "./clients/$listener\-$client.txt" == 1) {
		# Open their profile.
		open (PRO, "./clients/$listener\-$client.txt");
		my @data = <PRO>;
		close (PRO);

		chomp @data;

		# Load their profile into the hash.
		foreach my $line (@data) {
			my ($what,$is) = split(/=/, $line, 2);
			$what = lc($what);
			$what =~ s/ //g;

			$chaos->{_users}->{$client}->{$what} = $is;
		}
	}
	else {
		# Create a new profile. Remember to try and keep everything
		# you ever plan on needing here. It is very difficult to change
		# variable names later without deleting everybody's profile.
		open (NEW, ">./clients/$listener\-$client.txt");
		print NEW "Name=$client\n"
			. "Age=undefined\n"
			. "Sex=undefined\n"
			. "Location=undefined\n"
			. "Points=0\n"
			. "Stars=0\n"
			. "Time=undefined\n"
			. "Personality=neutral\n"
			. "Color=undefined\n"
			. "Book=undefined\n"
			. "Band=undefined\n"
			. "Job=undefined\n"
			. "Spouse=undefined\n"
			. "Sexuality=heterosexual\n"
			. "Website=undefined\n";
		close (NEW);

		# And reload their profile with the appropriate data.
		delete $chaos->{_users}->{$client};
		&profile_get ($client,$listener);
	}

	# Return true.
	return 1;
}
1;