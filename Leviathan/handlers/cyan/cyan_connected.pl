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
# CYAN Handler: connected
#  Description: Called when CyanChat's server recognizes us.

sub cyan_connected {
	my ($self) = @_;

	print "Connected to CyanChat!\n\n";

	# Log in.
	my $nick = $self->{_leviathan};
	$nick = $chaos->{bots}->{$nick}->{screenname};
	$self->login ($nick);
}
{
	Type        => 'handler',
	Name        => 'cyan_connected',
	Description => 'Called when CyanChat\'s server recognizes us.',
	Author      => 'Cerone Kirsle',
	Created     => '3:40 PM 5/14/2005',
	Updated     => '3:40 PM 5/14/2005',
	Version     => '1.0',
};