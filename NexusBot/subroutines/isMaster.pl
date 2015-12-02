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
#  Subroutine: isMaster                         #
# Description: Checks if user is the Master.    #
#################################################

sub isMaster {
	# Get the person in question from the shift.
	my ($client,$listener) = @_;

	# Get the permission data from the person's file.
	&profile_get ($client,$listener);

	# Initially they're not.
	my $is_ok = 0;

	# If they're who they say they are...
	if ($chaos->{users}->{$client}->{permission} eq "Master") {
		$is_ok = 1;
	}

	# Return if they're "okay"
	return $is_ok;
}
1;