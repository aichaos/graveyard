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
#       Brain: Rive
# Description: AiChaos RIVE: Rendering Intelligence Very Easily.

sub rive_get {
	# Incoming data for the brain.
	my ($brain,$self,$client,$msg,$omsg,$sn) = @_;

	# Call on the Rive brain.
	my ($code,$reply) = $chaos->{bots}->{$sn}->{_rive}->processOnce (
		nick    => $client,
		message => $omsg,
	);

	return $reply;
}
sub rive_load {
	# Incoming data for the brain.
	my ($bot,$brain,$dir) = @_;

	# Create a new RIVE.
	use AI::Rive;
	$chaos->{bots}->{$bot}->{_rive} = new AI::Rive (
		debug => 0,
		name  => $chaos->{bots}->{$bot}->{data}->{name},
		sex   => $chaos->{bots}->{$bot}->{data}->{sex},
		path  => $dir,
	);

	# All done!
	return 1;
}
{
	Type           => 'brain',
	Name           => 'Rive',
	Description    => 'AiChaos RIVE: Rendering Intelligence Very Easily.',
	RequireLoading => 1,
	LoadingSub     => 'rive_load',
	ReplySub       => 'rive_get',
	Author         => 'Cerone Kirsle',
	Created        => '3:17 PM 4/3/2005',
	Updated        => '3:19 PM 4/3/2005',
	Version        => '1.0',
};