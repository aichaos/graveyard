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
#       Brain: CML
#    Sub-Type: GET
# Description: Get a response from the CML 2.0 brain.

sub eliza_get {
	# Incoming data for the brain.
	my ($brain,$self,$client,$listener,$msg,$omsg,$sn) = @_;

	$brain = lc($brain);
	$brain =~ s/ //g;

	$sn = lc($sn);
	$sn =~ s/ //g;

	# Save some variables for latter use.
	my $date = localtime();
	my $secs = time();

	my $reply = $chaos->{$sn}->{_eliza}->transform ($msg);

	return $reply;
}
1;