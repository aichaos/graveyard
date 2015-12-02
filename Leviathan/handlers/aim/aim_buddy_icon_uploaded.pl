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
# AIM Handler: buddy_icon_uploaded
# Description: Called when your buddy icon has been uploaded.

sub aim_buddy_icon_uploaded {
	my ($aim) = @_;

	# Get some data.
	my $screenname = $aim->screenname();
	my $time = &get_timestamp();

	print "ChaosAIM: $screenname\'s buddy icon uploaded successfully!\n\n";
}
{
	Type        => 'handler',
	Name        => 'aim_buddy_icon_uploaded',
	Description => 'Called when your buddy icon has been uploaded.',
	Author      => 'Cerone Kirsle',
	Created     => '2:11 PM 11/20/2004',
	Updated     => '2:11 PM 11/20/2004',
	Version     => '1.0',
};