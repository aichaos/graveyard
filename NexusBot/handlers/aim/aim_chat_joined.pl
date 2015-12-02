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
# AIM Handler: chat_joined                      #
# Description: Handles chat joining.            #
#################################################

sub aim_chat_joined {
	my ($aim,$chatname,$chat) = @_;

	# Get the screenname and local time.
	my $screenname = $aim->screenname();
	my $time = localtime();

	# We'll handle IM's later, now we're just testing.
	print "$time\n";
	print "ChaosAIM: Joined room $chatname.\n\n";

	# Join the room.
	my $chat_msg = ("<body bgcolor=\"white\"><font face=\"Arial\" color=\"black\">"
		. "Hello room! :-)</font></body>");
	$aim->chat_send ($chat, $chat_msg, 1);
}
1;