# Subroutine: curses
# Sees if the word contains any form of bad word in it.

sub curses {
	# Get the message from the shift.
	my $msg = shift;

	# First, it's good.
	my $curse = 0;

	# Filter through bad words first
	my @worst_words = (
		"fuck",
		"fuq",
		"fuk",
		"bytch",
		"bitch",
		"whore",
		" hor",
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
		"ass");
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