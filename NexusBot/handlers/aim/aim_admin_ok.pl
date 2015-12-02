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
# AIM Handler: admin_ok                         #
# Description: Called when admin is "okay"      #
#################################################

sub aim_admin_ok {
	my ($aim,$request) = @_;

	# Get the screenname and local time.
	my $screenname = $aim->screenname();
	my $time = localtime();

	print "$time\n";
	print "ChaosAIM: Admin function \"$request\" completed.\n";
	print "\tScreenName: $screenname\n\n";
}
1;