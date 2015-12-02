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
# IRC Handler: connect
# Description: Called when you are connected.

sub irc_connect {
	# Get data from the server.
	my $self = shift;

	# Get localtime and our nick.
	my $stamp = &get_timestamp();
	my $sn = $self->nick;
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Join the channel.
	my $chan = $chaos->{bots}->{$sn}->{channel} || '#lobby';

	print "$stamp\n"
		. "ChaosIRC: $sn connected successfully!\n"
		. "ChaosIRC: Joining channel $chan...\n\n";

	$self->join ($chan);
	$self->topic ($chan);
}
{
	Type        => 'handler',
	Name        => 'irc_connect',
	Description => 'Called when you are connected.',
	Author      => 'Cerone Kirsle',
	Created     => '2:08 PM 12/19/2004',
	Updated     => '2:08 PM 12/19/2004',
	Version     => '1.0',
};