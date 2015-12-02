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
#  Subroutine: filter                           #
# Description: Filters the message out.         #
#################################################

sub filter {
	# Get the message from the shift.
	my $msg = shift;

	# Get filtering!

	# PUNCUATION
	$msg =~ s/\.//g; # .
	$msg =~ s/\,//g; # ,
	$msg =~ s/\?//g; # ?
	$msg =~ s/\!//g; # !
	$msg =~ s/\://g; # :
	$msg =~ s/\;//g; # ;
	$msg =~ s/\-//g; # -

	# SYMBOLS
	$msg =~ s/\~//g; # ~
	$msg =~ s/\@//g; # @
	$msg =~ s/\#//g; # #
	$msg =~ s/\$//g; # $
	$msg =~ s/\%//g; # %
	$msg =~ s/\^//g; # ^
	$msg =~ s/\&//g; # &
	$msg =~ s/\*//g; # *
	$msg =~ s/\_//g; # _
	$msg =~ s/\=//g; # =
	$msg =~ s/\+//g; # +
	$msg =~ s/\`//g; # `

	# BRACKETS
	$msg =~ s/\(//g; # (
	$msg =~ s/\)//g; # )
	$msg =~ s/\[//g; # [
	$msg =~ s/\]//g; # ]
	$msg =~ s/\{//g; # {
	$msg =~ s/\}//g; # }

	# Return the message.
	return $msg;
}
1;