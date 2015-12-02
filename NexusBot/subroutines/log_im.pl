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
#  Subroutine: log_im                           #
# Description: Log the Instant Messages.        #
#################################################

sub log_im {
	# Get the details from the shift.
	my ($client,$msg,$screenname,$reply,$listener) = @_;

	# Turn <BR>'s back into line breaks.
	$reply =~ s/<br>/\n/ig;

	# Remove HTML from the $reply.
	$reply =~ s/<(.|\n)+?>//g;

	# Print the conversation to the DOS console.
	my $time = localtime();
	print "$time\n"
		. "$listener: [$client] $msg\n"
		. "$listener: [$screenname] $reply\n\n";

	# Save this with the collective logs.
	open (CONVO, ">>./logs/$screenname.txt");
	print CONVO "$time\n"
		. "$listener: [$client] $msg\n"
		. "$listener: [$screenname] $reply\n\n";
	close (CONVO);

	# Save this specific conversation.
	open (LOG, ">>./logs/$listener/$client.txt");
	print LOG "$time\n"
		. "$listener: [$client] $msg\n"
		. "$listener: [$screenname] $reply\n\n";
	close (LOG);
}
1;