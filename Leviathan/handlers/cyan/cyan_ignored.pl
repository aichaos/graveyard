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
# CYAN Handler: ignored
#  Description: Ignored users.

sub cyan_ignored {
	my ($self,$ignore,$user) = @_;

	if ($ignore == 1) {
		print "CyanChat // Now ignoring $user\n\n";
	}
	else {
		print "CyanChat // Unignoring $user\n\n";
	}
}
{
	Type        => 'handler',
	Name        => 'cyan_ignore',
	Description => 'Ignored users.',
	Author      => 'Cerone Kirsle',
	Created     => '3:44 PM 5/14/2005',
	Updated     => '3:45 PM 5/14/2005',
	Version     => '1.0',
};