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
# MSN Handler: file
# Description: Handles file transfers?

sub msn_file {
	print "ChaosMSN: MSN_File: \@_ = " . join (", ", @_) . "\n\n";
}
{
	Type        => 'handler',
	Name        => 'msn_file',
	Description => 'Handles file transfers?',
	Author      => 'Cerone Kirsle',
	Created     => '1:12 PM 11/21/2004',
	Updated     => '1:12 PM 11/21/2004',
	Version     => '1.0',
};