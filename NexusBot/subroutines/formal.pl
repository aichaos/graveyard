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
#  Subroutine: formal                           #
# Description: Formalize a string.              #
#################################################

sub formal {
	# Get the string from the shift.
	my $string = shift;

	# Start it out lowercase.
	$string = lc($string);

	$string =~ s/(?<!')\b(\w+)/\u$1\E/g;

	return $string;
}
1;