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
# AIM Handler: buddy_out                        #
# Description: Handles outgoing buddies.        #
#################################################

sub aim_buddy_out {
	my ($aim,$client,$group) = @_;

	# Get the screenname and local time.
	my $screenname = $aim->screenname();
	my $time = localtime();

	#print "$time\n";
	#print "ChaosAIM: $client ($group) has signed out.\n";
	#print "\tScreenName: $screenname\n\n";
}
1;