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
#  Subroutine: filter
# Description: Basic filtering.

sub filter {
	# Get variables from the shift.
	my $msg = shift;

	# Make the message be purely alphanumeric.
	$msg =~ s/[^A-Za-z0-9 ]//ig;

	# Return the message.
	return $msg;
}
{
	Type        => 'subroutine',
	Name        => 'filter',
	Usage       => '$msg = &filter($msg)',
	Description => 'Basic filtering.',
	Author      => 'Cerone Kirsle',
	Created     => '4:21 PM 11/20/2004',
	Updated     => '4:21 PM 11/20/2004',
	Version     => '1.0',
};