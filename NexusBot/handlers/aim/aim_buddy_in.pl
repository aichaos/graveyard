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
# AIM Handler: buddy_in                         #
# Description: Handles incoming buddies.        #
#################################################

sub aim_buddy_in {
	my ($aim,$client,$group,$data) = @_;

	# Get the screenname and local time.
	my $screenname = $aim->screenname();
	my $time = localtime();

	#print "$time\n";
	#print "ChaosAIM: $client ($group) has just signed in.\n";
	#print "\tScreenName: $screenname\n\n";
}
1;