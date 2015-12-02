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
# AIM Handler: auth_challenge                   #
# Description: Called for authentication error. #
#################################################

sub aim_auth_challenge {
	my ($aim,$challenge,$hash) = @_;

	# Get our screenname and localtime.
	my $screenname = $aim->screenname();
	my $time = localtime();

	print "ChaosAIM: Authentication Challenge for $screenname: $challenge.\n\n";
}
1;