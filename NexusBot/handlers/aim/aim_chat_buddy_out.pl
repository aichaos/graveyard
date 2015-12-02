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
# AIM Handler: chat_buddy_out                   #
# Description: Handles outgoing chat buddies.   #
#################################################

sub aim_chat_buddy_out {
	my ($aim,$client,$chat) = @_;

	# Get the screenname and local time.
	my $screenname = $aim->screenname();
	my $time = localtime();

	print "$time\n";
	print "ChaosAIM: $client has left the chatroom.\n";
	print "\tScreenName: $screenname\n\n";

	my $font = get_aim_font ($screenname);
	$aim->chat_send ($chat, "$font Um.. good-bye, $client. :-(", 1);
}
1;