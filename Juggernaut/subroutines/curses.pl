#              ::.                   .:.
#               .;;:  ..:::::::.  .,;:
#                 ii;,,::.....::,;;i:
#               .,;ii:          :ii;;:
#             .;, ,iii.         iii: .;,
#            ,;   ;iii.         iii;   :;.
# .         ,,   ,iii,          ;iii;   ,;
#  ::       i  :;iii;     ;.    .;iii;.  ,,      .:;
#   .,;,,,,;iiiiii;:     ,ii:     :;iiii;;i:::,,;:
#     .:,;iii;;;,.      ;iiii:      :,;iiiiii;,:
#          :;        .:,,:..:,,.        .:;..
#           i.                  .        ,:
#           :;.         ..:...          ,;
#            ,;.    .,;iiiiiiii;:.     ,,
#             .;,  :iiiii;;;;iiiii,  :;:
#                ,iii,:        .,ii;;.
#                ,ii,,,,:::::::,,,;i;
#                ;;.   ...:.:..    ;i
#                ;:                :;
#                .:                ..
#                 ,                :
#  Subroutine: curses
# Description: Sees if the message contains a bad word.

sub curses {
	# Get the message from the shift.
	my $msg = shift;

	# First, it's good.
	my $curse = 0;

	# Filter through bad words first
	my @worst_words = (
		"invite", # To block MSN invitations
		"fuck",
		"fuq",
		"fuk",
		"fucc",
		"fawk",
		"fauk",
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
		"foreplay",
		"stfu",
		"azz",
		"hell",
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