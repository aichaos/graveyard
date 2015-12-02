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
#       Brain: Eliza
#    Sub-Type: LOAD
# Description: Creates a new Eliza bot for the current screenname.

sub eliza_load {
	# Incoming data for the brain.
	my ($bot,$brain,$dir) = @_;

	use Chatbot::Eliza;

	# Get the Eliza brain going.
	$chaos->{$bot}->{_eliza} = new Chatbot::Eliza (
		name       => $chaos->{$sn}->{data}->{name},
		memory_on  => 1,
	);

	# All done!
	return 1;
}
1;