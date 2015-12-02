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
#  Subroutine: isMod
# Description: Checks if the user is an mod.

sub isMod {
	# Get the user's name.
	my $client = shift;

	# Get the list and go through it.
	open (LIST, "./data/authority/moderators.txt");
	my @list = <LIST>;
	close (LIST);
	chomp @list;

	foreach my $item (@list) {
		return 1 if $client eq $item;
	}

	# If not... check for Admin.
	if (&isAdmin($client)) {
		return 1;
	}

	return 0;
}
{
	Type        => 'subroutine',
	Name        => 'isMod',
	Usage       => '$mod = &isMod($client)',
	Description => 'Checks if the user is an mod.',
	Author      => 'Cerone Kirsle',
	Created     => '4:10 PM 11/20/2004',
	Updated     => '4:10 PM 11/20/2004',
	Version     => '1.0',
};