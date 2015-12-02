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
#  Subroutine: isWarner
# Description: Checks if the user is a warner.

sub isWarner {
	# Get the user's name.
	my $client = shift;

	# Go through the list.
	open (LIST, "./data/warners.txt") or return 0;
	my @data = <LIST>;
	close (LIST);
	chomp @data;

	foreach my $item (@data) {
		return 1 if $client eq $item;
	}

	return 0;
}
{
	Type        => 'subroutine',
	Name        => 'isWarner',
	Usage       => '$warner = &isWarner($client)',
	Description => 'Checks if the user is a warner.',
	Author      => 'Cerone Kirsle',
	Created     => '1:58 PM 11/20/2004',
	Updated     => '1:58 PM 11/20/2004',
	Version     => '1.0',
};