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
# AIM Handler: admin_ok
# Description: Called on a successful administrative function.

sub aim_admin_ok {
	my ($aim,$reqtype) = @_;

	# Get some data.
	my $screenname = $aim->screenname();
	my $time = &get_timestamp();

	print "$time\n"
		. "ChaosAIM: Admin Success!\n"
		. "\tScreenName: $screenname\n"
		. "\tRequest Type: $reqtype\n\n";
}
{
	Type        => 'handler',
	Name        => 'aim_admin_ok',
	Description => 'Called on a successful administrative function.',
	Author      => 'Cerone Kirsle',
	Created     => '2:09 PM 11/20/2004',
	Updated     => '2:09 PM 11/20/2004',
	Version     => '1.0',
};