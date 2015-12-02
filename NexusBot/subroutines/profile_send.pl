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
#  Subroutine: profile_send                     #
# Description: Change the user's profile.       #
#################################################

sub profile_send {
	# Get the needed variables for this.
	my ($client,$listener,$variable,$value) = @_;

	$variable = lc($variable);
	$variable =~ s/ //g;

	my %userdata;
	my $final;

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

			if ($variable eq $what) {
				$final .= "$what=$value\n";
			}
			else {
				$final .= "$what=$is\n";
			}
		}

		open (NEW, ">./clients/$listener-$client.txt");
		print NEW $final;
		close (NEW);
	}
}
1;