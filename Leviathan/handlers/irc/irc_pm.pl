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
# IRC Handler: pm
# Description: Handles private messages.

sub irc_pm {
	# Get data from the server.
	my ($self,$event) = @_;

	# Send this to the IRC chat handler.
	&irc_chat ($self,$event);
}
{
	Type        => 'handler',
	Name        => 'irc_pm',
	Description => 'Handles private messages.',
	Author      => 'Cerone Kirsle',
	Created     => '2:19 PM 12/19/2004',
	Updated     => '2:19 PM 12/19/2004',
	Version     => '1.0',
};