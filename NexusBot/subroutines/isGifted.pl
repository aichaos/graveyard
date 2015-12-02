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
#  Subroutine: isGifted                         #
# Description: Checks if user is Gifted         #
#################################################

sub isGifted {
	# Get the person in question from the shift.
	my ($client,$listener) = @_;

	# Get the permission data from the person's file.
	&profile_get ($client,$listener);

	# Initially they're not.
	my $is_ok = 0;

	# If they're who they say they are...
	if ($chaos->{users}->{$client}->{permission} eq "Gifted") {
		$is_ok = 1;
	}

	# Return if they're "okay"
	return $is_ok;
}
1;