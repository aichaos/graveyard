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
#  Subroutine: curses                           #
# Description: Scan a string for bad language.  #
#################################################

sub curses {
	# Get the message from the shift.
	my $msg = shift;

	# First, it's good.
	my $curse = 0;

	# Filter through bad words first
	my @worst_words = (
		"invite", # To block MSN invitations
		"http",   # To stop idiots from advertising websites
		".com",   #
		".net",   #
		".org",   #
		".tk",    #
		"ftp",    # Stop FTP sites
		"fuck",
		"fuq",
		"fuk",
		"fucc",
		"cyber",
		"ciber",
		"bytch",
		"bitch",
		"whore",
		"slut",
		"dik",
		"dick",
		"dyke",
		"gay",
		"faq",
		"fag",
		"flamer",
		"fruitc",
		"fairy",
		"damm",
		"damn",
		"god",
		"shit",
		"sh!t",
		"shyt",
		"nigger",
		"nig",
		"kill",
		"puss",
		"cunt",
		"suck",
		"suk",
		"prost",
		"ass",
		"penis",
		"vagin",
		"cock",
		"hump",
		"boob",
		"anal",
		"butt",);
	foreach $item (@worst_words) {
		if ($msg =~ /$item/i) {
			$curse = 1;
		}
	}

	# Words like "bi" that come at the end of the sentence.
	if ($msg =~ /bi$/i) {
		$curse = 1;
	}

	# Return if it's a curse.
	return $curse;
}
1;