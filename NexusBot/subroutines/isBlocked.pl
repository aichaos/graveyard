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
#  Subroutine: isBlocked                        #
# Description: Checks if the user is blocked.   #
#################################################

sub isBlocked {
	# Get the name in question from the shift.
	my $client = shift;

	# Initially they're okay.
	my $blocked = 0;
	my $item;

	# Load the blocked list.
	open (LIST, "./data/blocked.txt");
	my @blocks = <LIST>;
	close (LIST);

	# Go through the list.
	foreach $item (@blocks) {
		chomp $item;
		$item = lc($item);
		$item =~ s/ //g;
			if ($client eq $item) {
			$blocked = 1;
		}
	}

	# If they're a warner, attack them.
	if ($blocked == 1) {
		print "CKS // Ignoring message from $client (blocked).\n\n";
	}

	# Return if they're a warner.
	return $blocked;
}
1;