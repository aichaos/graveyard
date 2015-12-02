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
#  Subroutine: get_msn_font                     #
# Description: Returns the bot's MSN fonts.     #
#################################################

sub get_msn_font {
	# Get the screenname from the shift.
	my $screenname = shift;

	# Find the font file.
	my $file = $chaos->{$screenname}->{font};

	# Open the file.
	open (FONT, $file);
	my @font_info = <FONT>;
	close (FONT);

	# Go through the font file.
	my %font_data;
	foreach $line (@font_info) {
		chomp $line;
		my ($what,$is) = split(/=/, $line);
		$what = lc($what);
		$what =~ s/ //g;
		$font_data{$what} = $is;
	}

	# Return the font.
	return ($font_data{"fontname"}, $font_data{"fontcolor"});
}
1;