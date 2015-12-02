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
# AIM Handler: im_ok                            #
# Description: Called when an IM was sent.      #
#################################################

sub aim_im_ok {
	my ($aim,$to,$id) = @_;

	# Get the screenname and local time.
	my $screenname = $aim->screenname();
	my $time = localtime();

	# We don't REALLY need to print this do we?
}
1;