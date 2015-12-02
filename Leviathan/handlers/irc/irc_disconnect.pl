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
# IRC Handler: disconnect
# Description: Handles disconnections.

sub irc_disconnect {
	# Get data from the server.
	my ($self,$event) = @_;

	my $stamp = &get_timestamp();

	print "$stamp\n"
		. "ChaosIRC: Disconnected from " . $event->from . " ("
		. ($event->args)[0] . ")\n"
		. "ChaosIRC: Attempting to reconnect...\n\n";
	$self->connect ();
}
{
	Type        => 'handler',
	Name        => 'irc_disconnect',
	Description => 'Handles disconnections.',
	Author      => 'Cerone Kirsle',
	Created     => '2:11 PM 12/19/2004',
	Updated     => '2:11 PM 12/19/2004',
	Version     => '1.0',
};