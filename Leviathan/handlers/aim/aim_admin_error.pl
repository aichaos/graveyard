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
# AIM Handler: admin_error
# Description: Handles AIM admin errors.

sub aim_admin_error {
	my ($aim,$reqtype,$error,$url) = @_;

	# Get some data.
	my $screenname = $aim->screenname();
	my $time = &get_timestamp();

	print $time . "\n"
		. "ChaosAIM: Admin Error:\n"
		. "\tScreenName: $screenname\n"
		. "\tRequest Type: $reqtype\n"
		. "\tError: $error\n"
		. "\tURL: $url\n\n";
}
{
	Type        => 'handler',
	Name        => 'aim_admin_error',
	Description => 'Handles AIM administrative errors.',
	Author      => 'Cerone Kirsle',
	Created     => '2:07 PM 11/20/2004',
	Updated     => '2:07 PM 11/20/2004',
	Version     => '1.0',
};