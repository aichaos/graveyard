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
# AIM Handler: buddy_icon_downloaded
# Description: Called when a user's buddy icon has been downloaded.

sub aim_buddy_icon_downloaded {
	my ($aim,$client,$icon) = @_;

	# Get some data.
	my $screenname = $aim->screenname();
	my $time = &get_timestamp();

	# A buddy icon has been downloaded...
}
{
	Type        => 'handler',
	Name        => 'aim_buddy_icon_downloaded',
	Description => 'Called when a user\'s buddy icon has been downloaded.',
	Author      => 'Cerone Kirsle',
	Created     => '2:10 PM 11/20/2004',
	Updated     => '2:10 PM 11/20/2004',
	Version     => '1.0',
};