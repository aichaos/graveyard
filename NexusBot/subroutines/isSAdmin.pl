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
#  Subroutine: isSAdmin                         #
# Description: Checks if user is Super Admin.   #
#################################################

sub isSAdmin {
	# Get the person in question from the shift.
	my ($client,$listener) = @_;

	# Get the permission data from the person's file.
	&profile_get ($client,$listener);

	# Initially they're not.
	my $is_ok = 0;

	# If they're who they say they are...
	if ($chaos->{users}->{$client}->{permission} eq "Super Admin") {
		$is_ok = 1;
	}

	# Return if they're "okay"
	return $is_ok;
}
1;