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
# AIM Handler: buddylist_error
# Description: Handles buddylist errors.

sub aim_buddylist_error {
	my ($aim,$error,$what) = @_;

	# Get some data.
	my $screenname = $aim->screenname();
	my $time = &get_timestamp();

	print "$time\n"
		. "ChaosAIM: Buddy List Error $error: $what\n"
		. "\tScreenName: $screenname\n\n";
}
{
	Type        => 'handler',
	Name        => 'aim_buddylist_error',
	Description => 'Handles buddylist errors.',
	Author      => 'Cerone Kirsle',
	Created     => '2:19 PM 11/20/2004',
	Updated     => '2:19 PM 11/20/2004',
	Version     => '1.0',
};