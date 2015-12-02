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
# CYAN Handler: welcome
#  Description: CyanChat's server welcomes us.

sub cyan_welcome {
	my ($self,$msg) = @_;

	print "ChaosCYAN: [ChatServer] $msg\n";
}
{
	Type        => 'handler',
	Name        => 'cyan_welcome',
	Description => 'ChatChat\'s server welcomes us.',
	Author      => 'Cerone Kirsle',
	Created     => '3:41 PM 5/14/2005',
	Updated     => '3:41 PM 5/14/2005',
	Version     => '1.0',
};