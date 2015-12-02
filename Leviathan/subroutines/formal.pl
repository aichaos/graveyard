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
#  Subroutine: formal
# Description: Formalizes a string.

sub formal {
	# Get the string from the shift.
	my $string = shift;

	# Start it out lowercase.
	$string = lc($string);

	$string =~ s/(?<!')\b(\w+)/\u$1\E/g;

	return $string;
}
{
	Type        => 'subroutine',
	Name        => 'formal',
	Usage       => '$string = &formal($string)',
	Description => 'Formalizes A String.',
	Author      => 'Cerone Kirsle',
	Created     => '3:17 PM 11/24/2004',
	Updated     => '3:17 PM 11/24/2004',
	Version     => '1.0',
};