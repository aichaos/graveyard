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
#  Subroutine: isWarner                         #
# Description: Checks if the user is a warner.  #
#################################################

sub isWarner {
	# Get the name in question from the shift.
	my ($aim,$client) = @_;

	# Initially they're okay.
	my $warner = 0;

	# Load the warners list, if it exists.
	if (-e "./data/warners.txt" == 1) {
		open (LIST, "./data/warners.txt");
		my @warners = <LIST>;
		close (LIST);

		# Go through the list.
		foreach my $item (@warners) {
			chomp $item;
			$item = lc($item);
			$item =~ s/ //g;

			if ($client eq $item) {
				$warner = 1;
			}
		}
	}

	# If they're a warner, attack them.
	if ($warner == 1) {
		$aim->evil ($client, 0);
		$aim->add_deny ($client);
		print "CKS // I have attacked that idiot warner $client.\n\n";
	}

	# Return if they're a warner.
	return $warner;
}
1;