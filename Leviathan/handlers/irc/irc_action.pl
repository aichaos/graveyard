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
# IRC Handler: action
# Description: Called when a user does a /me command in IRC.

sub irc_action {
	# Get data from the server.
	my ($self,$event) = @_;
	my $client = $event->nick;
	my @msg = $event->args;

	# Get timestamp.
	my $stamp = &get_timestamp();

	# Print it.
	print "$stamp\n"
		. "ChaosIRC: *** [$client] " . join (" ",@msg) . " ***\n\n";
}
{
	Type        => 'handler',
	Name        => 'irc_action',
	Description => 'Called when a user does a /me command in IRC.',
	Author      => 'Cerone Kirsle',
	Created     => '2:02 PM 12/19/2004',
	Updated     => '2:02 PM 12/19/2004',
	Version     => '1.0',
};