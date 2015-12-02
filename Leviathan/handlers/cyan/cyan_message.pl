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
# CYAN Handler: message
#  Description: Publicly broadcasted CyanChat messages.

sub cyan_message {
	my ($self,$nick,$level,$addr,$msg) = @_;

	my $stamp = &timestamps ('local', 'hh:mm:ss');
	print "ChaosCYAN: $stamp [$nick] $msg\n";
}
{
	Type        => 'handler',
	Name        => 'cyan_message',
	Description => 'Publicly broadcasted CyanChat messages.',
	Author      => 'Cerone Kirsle',
	Created     => '3:43 PM 5/14/2005',
	Updated     => '3:43 PM 5/14/2005',
	Version     => '1.0',
};