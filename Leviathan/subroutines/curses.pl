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
# Description: Detects foul language.

sub curses {
	# Get the message from the shift.
	my $msg = shift;

	# First, it's good.
	my $curse = 0;

	my @words = split(/\s+/, $msg);

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
		"butt",
	);
	foreach my $item (@worst_words) {
		foreach my $word (@words) {
			if ($word =~ /^$item$/i) {
				$curse = 1;
			}
		}
	}

	# Words like "bi" that come at the end of the sentence.
	if ($msg =~ /bi$/i) {
		$curse = 1;
	}

	# Return if it's a curse.
	return $curse;
}
{
	Type        => 'subroutine',
	Name        => 'curses',
	Usage       => '$cursing = &curses($msg)',
	Description => 'Detects foul language.',
	Author      => 'Cerone Kirsle',
	Created     => '3:17 PM 11/24/2004',
	Updated     => '3:17 PM 11/24/2004',
	Version     => '1.0',
};