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
# AIM Handler: error                            #
# Description: Handles AIM errors.              #
#################################################

sub aim_error {
	my ($aim,$connection,$error,$description,$fatal) = @_;

	# Get the screenname and local time.
	my $screenname = $aim->screenname();
	my $time = localtime();

	print "$time\n";
	print "ChaosAIM: ERROR $error: $description\n";
	print "\tScreenName: $screenname\n";

	if ($fatal) {
		print "\tYou have been disconnected.\n\n";
	}
	else {
		print "\tNot a fatal error.\n\n";
	}
}
1;