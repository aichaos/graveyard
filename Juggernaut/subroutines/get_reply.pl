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
#  Subroutine: get_reply
# Description: Gets the reply.

sub get_reply {
	# Get variables from the shift.
	my ($brain,$self,$client,$listener,$msg,$omsg,$sn) = @_;

	$brain = lc($brain);
	$brain =~ s/ //g;

	# Send this data to the GET handler for this brain.
	my $get = $brain . '_get';
	return "Could not get \$brain ($brain) at get_reply.pl" unless (-e "./brains/$get\.pl");
	my $reply = &{$get} ($brain,$self,$client,$listener,$msg,$omsg,$sn) or return "Error in brain \"$brain\" GET handler.";

	return $reply;
}
1;