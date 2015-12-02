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
# Description: Loads the profile of one user.

sub profile_get {
	# User's name.
	my $client = shift;

	# If their profile exists...
	if (-e "./clients/$client\.txt") {
		# Return if the profile has already been loaded.
		return if exists $chaos->{clients}->{$client}->{name};

		# Load their profile.
		open (PROFILE, "./clients/$client\.txt");
		my @data = <PROFILE>;
		close (PROFILE);
		chomp @data;

		# Go through the profile.
		foreach my $line (@data) {
			my ($what,$is) = split(/=/, $line, 2);
			$what = lc($what);
			$what =~ s/ //g;

			$chaos->{clients}->{$client}->{$what} = $is;
		}

		# Return.
		return 1;
	}
	else {
		# Create a new profile.
		delete $chaos->{clients}->{$client} if exists $chaos->{clients}->{$client};

		open (NEW, ">./clients/$client\.txt");
		print NEW "points=0\n"
			. "stars=0\n"
			. "blocked=0\n"
			. "blocks=0\n"
			. "expire=0\n"
			. "exmins=0\n\n"
			. "// Custom Fields //\n";
		close (NEW);

		# Load the profile.
		&profile_get ($client);
	}

	return 0;
}
{
	Type        => 'subroutine',
	Name        => 'profile_get',
	Usage       => '&profile_get($client)',
	Description => 'Loads a user\'s profile.',
	Author      => 'Cerone Kirsle',
	Created     => '8:51 AM 11/21/2004',
	Updated     => '8:51 AM 11/21/2004',
	Version     => '1.0',
};