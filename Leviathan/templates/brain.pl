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
#       Brain: Template
# Description: Simple Brain Template.

sub template_get {
	# Incoming data for the brain.
	my ($brain,$self,$client,$msg,$omsg,$sn) = @_;

	$brain = lc($brain);
	$brain =~ s/ //g;
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Return a reply.
	return "You said: $msg";
}
sub template_load {
	# Incoming data for the brain.
	my ($bot,$brain,$dir) = @_;

	# Initialize the brain here (if it needs it). If it doesn't
	# need to be initialized, delete this sub and then flip the
	# "RequireLoading" switch to 0 (below).

	# Return true after loading.
	return 1;
}
{
	Type           => 'brain',
	Name           => 'Template',
	Description    => 'Simple Brain Template',
	RequireLoading => 1,
	LoadingSub     => 'template_load',
	ReplySub       => 'template_get',
	Author         => 'Your Name',
	Created        => '12:00 AM 01/01/2000',
	Updated        => '12:00 AM 01/01/2000',
	Version        => '1.0',
};
