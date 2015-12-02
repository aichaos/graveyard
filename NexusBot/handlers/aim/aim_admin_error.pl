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
# AIM Handler: admin_error                      #
# Description: Handles administrative errors.   #
#################################################

sub aim_admin_error {
	my ($aim,$reqtype,$error,$url) = @_;

	# Get the screenname and local time.
	my $screenname = $aim->screenname();
	my $time = localtime();

	print "$time\n";
	print "ChaosAIM: Admin Error!\n";
	print "\tScreenName: $screenname\n";
	print "\tRequest Type: $reqtype\n";
	print "\tError: $error\n";
	print "\tURL: $url\n\n";
}
1;