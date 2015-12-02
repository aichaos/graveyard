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
# AIM Handler: rate_alert
# Description: Handles rate alert errors.

sub aim_rate_alert {
	my ($aim,$level,$clear,$window,$worrisome) = @_;

	# Get some data.
	my $screenname = $aim->screenname();
	my $time = &get_timestamp();

	print "$time\n"
		. "ChaosAIM: Rate Alert Error:\n"
		. "\tScreenName: $screenname\n"
		. "\tClear: $clear\n"
		. "\tWindow: $window\n"
		. "\tWorrisome: $worrisome\n\n";
}
{
	Type        => 'handler',
	Name        => 'aim_rate_alert',
	Description => 'Handles rate alert errors.',
	Author      => 'Cerone Kirsle',
	Created     => '3:07 PM 11/20/2004',
	Updated     => '3:08 PM 11/20/2004',
	Version     => '1.0',
};