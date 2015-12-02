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
#  Subroutine: isCks
# Description: Checks if the user is a CKS Administrator or Leader.

sub isCks {
	# Get the user's name.
	my $client = shift;

	# Get the list and go through it.
	open (LIST, "./data/authority/aichaos.txt");
	my @list = <LIST>;
	close (LIST);
	chomp @list;

	foreach my $item (@list) {
		return 1 if $client eq $item;
	}

	return 0;
}
{
	Type        => 'subroutine',
	Name        => 'isCks',
	Usage       => '$cks = &isCks($client)',
	Description => 'Checks if the user is a CKS Administrator or Leader.',
	Author      => 'Cerone Kirsle',
	Created     => '8:36 PM 12/29/2004',
	Updated     => '8:36 PM 12/29/2004',
	Version     => '1.0',
};