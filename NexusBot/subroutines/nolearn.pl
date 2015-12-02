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
#  Subroutine: nolearn                          #
# Description: The bot's chance to respond.     #
#################################################

sub nolearn {
	# Get all the variables needed from the shift.
	my ($client,$fmsg,$msg) = @_;

	if (lc($msg) eq "connect") {
		return "Hello there $client and thanks for connecting!";
	}

	# Open the reply data.
	open (DATA, "./data/brain.txt");
	my @data = <DATA>;
	close (DATA);
	chomp @data;

	# Go through the replies.
	my $reply;
	my $found = 0;
	foreach $line (@data) {
		my ($what,$is) = split(/\]\[/, $line, 2);
		if ($found == 0) {
			if ($msg =~ /$what/i) {
				my @rand = split(/\|/, $is);
				$reply = $rand [ int(rand(scalar(@rand))) ];
				$found = 1;
			}
		}
	}

	# Return the reply.
	return $reply;
}
1;