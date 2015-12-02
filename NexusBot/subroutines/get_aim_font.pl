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
#  Subroutine: get_aim_font                     #
# Description: Returns the bot's AIM fonts.     #
#################################################

sub get_aim_font {
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
	my $font = ("<body bgcolor=\"$font_data{'background'}\" link=\"$font_data{'linkcolor'}\">"
		. "<font face=\"$font_data{'fontname'}\" size=\"$font_data{'fontsize'}\" "
		. "color=\"$font_data{'fontcolor'}\">$font_data{'style'}");
	return $font;
}
1;