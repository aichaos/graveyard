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
# CYAN Handler: name_accepted
#  Description: Handles good names.

sub cyan_name_accepted {
	my $self = shift;

	# Say hi!
	my $nick = $self->nick();
	$nick = lc($nick);
	$nick =~ s/ //g;
	&queue ($nick, 3, "\$chaos->{bots}->{$nick}->{client}->sendMessage ('Shorah!');");
}
{
	Type        => 'handler',
	Name        => 'cyan_name_accepted',
	Description => 'Handles good names.',
	Author      => 'Cerone Kirsle',
	Created     => '3:46 PM 5/14/2005',
	Updated     => '3:47 PM 5/14/2005',
	Version     => '1.0',
};