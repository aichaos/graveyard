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
# HTTP Handler: im_in                           #
#  Description: Handles incoming IM's.          #
#################################################

sub http_im_in {
	my ($client,$msg) = @_;
	my $http;

	# Get the screenname and local time.
	my $screenname = "ChaosHTTP";
	my $time = localtime();

	# Format the user's screenname.
	$client = lc($client);
	$client =~ s/ //g;

	# Filter HTML from the message.
	$msg =~ s/<(.|\n)+?>//g;

	# Save an unfiltered copy.
	my $omsg = $msg;

	# See if this is a command.
	my ($is_command,$reply) = commands ($http,$client,$msg,"HTTP");

	# If it's not a command, continue.
	if ($is_command == 0 && $chaos->{users}->{$client}->{mute} != 1) {
		# Filter the message out.
		$msg = filter($msg);

		# Send the message to the brain.
		$reply = brain ($client,$msg,$omsg,"HTTP",0);
	}

	$reply =~ s/\n/<br>/ig;

	# Log this IM.
	&log_im ($client,$omsg,$screenname,$reply,"ChaosHTTP");

	# Return the reply.
	return $reply;
}
1;