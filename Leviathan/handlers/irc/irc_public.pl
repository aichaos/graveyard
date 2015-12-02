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
# IRC Handler: public
# Description: Handles public messages.

sub irc_public {
	# Get data from the server.
	my ($self,$event) = @_;
	my @to = $event->to;
	my ($nick,$sn) = ($event->nick, $self->nick);
	my @data = $event->args;
	my $msg = join (" ", @data);

	my $stamp = &get_timestamp ();

	print "$stamp\n"
		. "ChaosIRC: [$nick] $msg\n\n";
}
{
	Type        => 'handler',
	Name        => 'irc_public',
	Description => 'Handles public messages.',
	Author      => 'Cerone Kirsle',
	Created     => '2:21 PM 12/19/2004',
	Updated     => '2:21 PM 12/19/2004',
	Version     => '1.0',
};