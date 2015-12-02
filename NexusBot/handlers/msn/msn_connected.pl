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
# MSN Handler: connected                        #
# Description: Called when the bot connects.    #
#################################################

sub msn_connected {
	my $self = shift;

	# This is what the bot does after
	# successfully connecting to MSN...
	print "ChaosMSN: Connected to MSN!\n\n";

	# Set the nickname.
	my $screenname = $self->GetMaster->{Handle};
	my $name = $chaos->{$screenname}->{nick};

	$self->set_name ($name);
}
1;