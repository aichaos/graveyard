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
# CYAN Handler: error
#  Description: Handles errors.

sub cyan_error {
	my ($self,$error,$string) = @_;

	my $stamp = &get_timestamp();
	print "ChaosCYAN: Error $error: $string\n\n";
}
{
	Type        => 'handler',
	Name        => 'cyan_error',
	Description => 'Handles errors.',
	Author      => 'Cerone Kirsle',
	Created     => '3:48 PM 5/14/2005',
	Updated     => '3:48 PM 5/14/2005',
	Version     => '1.0',
};