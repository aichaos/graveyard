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
# CYAN Handler: buddies
#  Description: Buddy handlers.

sub cyan_buddy_in {
	my ($self,$nick,$level,$addr,$msg) = @_;

	# No comments.
}
sub cyan_buddy_out {
	my ($self,$nick,$level,$addr,$msg) = @_;

	# No comments.
}
sub cyan_buddy_here {
	my ($self,$nick,$level,$addr,$msg) = @_;

	# No comments.
}
{
	Type        => 'handler',
	Name        => 'cyan_buddies',
	Description => 'Ignored users.',
	Author      => 'Cerone Kirsle',
	Created     => '3:45 PM 5/14/2005',
	Updated     => '3:46 PM 5/14/2005',
	Version     => '1.0',
};