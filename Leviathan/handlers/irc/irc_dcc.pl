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
# IRC Handler: dcc
# Description: Handles DCC requests.

sub irc_dcc {
	# Get data from the server.
	my ($self,$event) = @_;
	my $type = ($event->args)[1];
	$type = uc($type);

	if ($type eq 'CHAT') {
		$self->new_chat ($event);
	}
}
{
	Type        => 'handler',
	Name        => 'irc_dcc',
	Description => 'Handles DCC requests.',
	Author      => 'Cerone Kirsle',
	Created     => '2:10 PM 12/19/2004',
	Updated     => '2:10 PM 12/19/2004',
	Version     => '1.0',
};