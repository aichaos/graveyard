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
# AIM Handler: rate_alert                       #
# Description: Handles rate alerts.             #
#################################################

sub aim_rate_alert {
	my ($aim,$level,$clear,$window,$worrisome) = @_;

	# Get the screenname and local time.
	my $screenname = $aim->screenname();
	my $time = localtime();

	print "$time\n";
	print "ChaosAIM: Rate Alert Error\n";
	print "\tScreenName: $screenname\n";
	print "\tLevel: $level\n";
	print "\tClear: Send no more than $window commands in $clear milliseconds.\n";
	print "\tWorrisome: $worrisome\n\n";
}
1;