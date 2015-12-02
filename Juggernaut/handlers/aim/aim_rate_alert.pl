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
# AIM Handler: aim_rate_alert
# Description: Handles AIM rate alert errors.

sub aim_rate_alert {
	# Get variables from the server.
	my ($aim,$level,$clear,$window,$worrisome) = @_;

	my $screenname = $aim->screenname();
	my $time = localtime();

	print "ChaosAIM: Rate Alert Error:\n"
		. "\tScreenName: $screenname\n"
		. "\tClear: $clear\n"
		. "\tWindow: $window\n"
		. "\tWorrisome: $worrisome\n\n";
}
1;