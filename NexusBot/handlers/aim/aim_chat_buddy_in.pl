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
# AIM Handler: chat_buddy_in                    #
# Description: Handles incoming chat buddies.   #
#################################################

sub aim_chat_buddy_in {
	my ($aim,$client,$chat,$data) = @_;

	# Get the screenname and local time.
	my $screenname = $aim->screenname();
	my $time = localtime();

	print "$time\n";
	print "ChaosAIM: $client has joined the chatroom.\n";
	print "\tScreenName: $screenname\n\n";

	my $font = get_aim_font ($screenname);
	$aim->chat_send ($chat, "$font Hello $client! :-)", 1);
}
1;