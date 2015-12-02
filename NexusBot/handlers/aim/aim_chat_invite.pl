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
# AIM Handler: chat_invite                      #
# Description: Handles chat invitations.        #
#################################################

sub aim_chat_invite {
	my ($aim,$client,$msg,$chat,$url) = @_;

	# Get the screenname and local time.
	my $screenname = $aim->screenname();
	my $time = localtime();

	# We'll handle IM's later, now we're just testing.
	print "$time\n";
	print "ChaosAIM: Recieved a chat invitation.\n";
	print "\t   From: $client\n";
	print "\t     To: $screenname\n";
	print "\tMessage: $msg\n";
	print "\t   Name: $chat\n\n";

	# Join the room.
	$aim->chat_accept ($url);
}
1;