#################################################
#                                               #
#     #####    #                                #
#    #     #   #                                #
#   #       #  #                                #
#  #           #            #                   #
#  #           ####     #####     ####    ####  #
#  #           #   #   #    #    #    #  #      #
#   #       #  #    #  #    #    #    #   ###   #
#    #     #   #    #  #    #    #    #      #  #
#     #####    #    #   #### ##   ####   ####   #
#                                               #
#         A . I .      T e c h n o l o g y      #
#-----------------------------------------------#
#  Subroutine: profile_get                      #
# Description: Returns the user's profile.      #
#################################################

sub profile_get {
	# Get the needed variables for this.
	my ($client,$listener) = @_;

	# If their file exists, open it.
	if (-e "./clients/$listener-$client.txt" == 1) {
		open (FILE, "./clients/$listener-$client.txt");
		my @data = <FILE>;
		close (FILE);

		# Go through the file.
		foreach $line (@data) {
			chomp $line;
			my ($what,$is) = split(/=/, $line);
			$what = lc($what);
			$what =~ s/ //g;

			$chaos->{users}->{$client}->{$what} = $is;
		}
	}
	else {
		# Create a new file.
		open (NEW, ">./clients/$listener-$client.txt");
		print NEW ("Permission=Client\n"
			. "Messages=0\n"
			. "Name=$client\n"
			. "Age=undefined\n"
			. "Sex=undefined\n"
			. "Location=undefined\n"
			. "Color=undefined\n"
			. "Band=undefined\n"
			. "Book=undefined\n"
			. "Sexuality=heterosexual\n"
			. "Job=undefined");
		close (NEW);
	}

	# If they have an invalid permission...
	my $is_valid = 0;
	my @valid_permissions = (
		"Client", "Gifted", "Keeper", "Moderator", "Super Moderator",
		"Admin", "Super Admin", "Master",
	);
	foreach $item (@valid_permissions) {
		if ($chaos->{users}->{$client}->{permission} eq $item) {
			$is_valid = 1;
		}
	}

	# If it's invalid, re-set it to Client.
	if ($is_valid == 0) {
		&profile_send ($client,$listener,"permission","Client");
	}
}
1;