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
# IRC Handler: nick_taken
# Description: Handler for if your nick is taken.

sub irc_nick_taken {
	# Get data from the server.
	my $self = shift;

	my $stamp = &get_timestamp();
	my $sn = $self->nick;
	$sn = lc($sn);
	$sn =~ s/ //g;

	print "$stamp\n"
		. "ChaosIRC: The nickname $sn is already in use.\n"
		. "ChaosIRC: Removing this connection...\n\n";

	# Remove this bot.
	delete $chaos->{bots}->{$sn};
}
{
	Type        => 'handler',
	Name        => 'irc_nick_taken',
	Description => 'Handler for if your nick is taken.',
	Author      => 'Cerone Kirsle',
	Created     => '2:18 PM 12/19/2004',
	Updated     => '2:18 PM 12/19/2004',
	Version     => '1.0',
};