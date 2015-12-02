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
#  Subroutine: get_timestamp
# Description: Returns the generic timestamp.

sub get_timestamp {
	# Get the time stamp settings.
	my $stamp = $chaos->{config}->{time};

	# Filter in the time.
	$stamp = &timestamps ('local',$stamp);
	return $stamp;
}
{
	Type        => 'subroutine',
	Name        => 'get_timestamp',
	Usage       => '&get_timestamp()',
	Description => 'Returns the generic timestamp.',
	Author      => 'Cerone Kirsle',
	Created     => '2:05 PM 11/20/2004',
	Updated     => '2:06 PM 11/20/2004',
	Version     => '1.0',
};