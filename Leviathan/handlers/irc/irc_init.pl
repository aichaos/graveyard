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
# IRC Handler: init
# Description: Called on initialization.

sub irc_init {
	# Get data from the server.
	my ($self,$event) = @_;
	my @args = $event->args();
	shift (@args);

	my $stamp = &get_timestamp();

	print "$stamp\n"
		. "ChaosIRC: *** @args\n\n"
}
{
	Type        => 'handler',
	Name        => 'irc_init',
	Description => 'Called on initialization.',
	Author      => 'Cerone Kirsle',
	Created     => '2:13 PM 12/19/2004',
	Updated     => '2:13 PM 12/19/2004',
	Version     => '1.0',
};