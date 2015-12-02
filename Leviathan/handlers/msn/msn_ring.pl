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
# MSN Handler: ring
# Description: Called when somebody TRIES to start a conversation with us.

sub msn_ring {
	my ($self,$client,$name) = @_;

	# Format the client.
	$client = lc($client);
	$client =~ s/ //g;
	$client = 'MSN-' . $client;

	# If blocked...
	if (&isBlocked($client)) {
		return 0;
	}
	else {
		return 1;
	}
}
{
	Type        => 'handler',
	Name        => 'msn_ring',
	Description => 'Called when somebody TRIES to start a conversation with us.',
	Author      => 'Cerone Kirsle',
	Created     => '1:23 PM 11/21/2004',
	Updated     => '1:23 PM 11/21/2004',
	Version     => '1.0',
};