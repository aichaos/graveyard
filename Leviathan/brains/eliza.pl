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
#       Brain: Eliza
# Description: The Perl implementation of the Eliza bot.

sub eliza_get {
	# Incoming data for the brain.
	my ($brain,$self,$client,$msg,$omsg,$sn) = @_;

	use Chatbot::Eliza;

	$brain = lc($brain);
	$brain =~ s/ //g;
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Does this user's personal Eliza exist?
	if (!exists $chaos->{clients}->{$client}->{_eliza}) {
		$chaos->{clients}->{$client}->{_eliza} = new Chatbot::Eliza {
			name      => $chaos->{bots}->{$sn}->{_data}->{name},
			memory_on => 1,
		};
	}

	# Get a reply.
	$msg = lc($msg);
	my $reply = $chaos->{clients}->{$client}->{_eliza}->transform ($msg);
	return $reply;
}
{
	Type           => 'brain',
	Name           => 'Eliza',
	Description    => 'The Perl implementation to Eliza.',
	RequireLoading => 0,
	LoadingSub     => '',
	ReplySub       => 'eliza_get',
	Author         => 'Cerone Kirsle',
	Created        => '1:09 PM 11/20/2004',
	Updated        => '1:10 PM 11/20/2004',
	Version        => '1.0',
};