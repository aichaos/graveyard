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
#  Subroutine: get_comm_code                    #
# Description: Gets the command code.           #
#################################################

sub get_comm_code {
	# Load the command file.
	open (SYM, "./data/command.txt");
	my $sym = <SYM>;
	close (SYM);

	# If there isn't a symbol, set it to the default.
	if ($sym eq "") {
		$sym = "!";
	}

	# Return the symbol.
	return $sym;
}
1;