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
# HTTP Handler: im_in
#  Description: Handles HTTP messages.

sub http_im_in {
	my ($sn,$client,$msg) = @_;

	# Get some data.
	my $time = &get_timestamp();

	$client = 'HTTP-' . $client;

	# Save an original copy.
	my $omsg = $msg;

	my $self = "";

	# Get a reply.
	my $reply = &on_im ($self,$sn,$client,$msg,$omsg);

	$reply =~ s/<:>/<p>/ig;

	# Return the reply.
	return $reply;
}
{
	Type        => 'handler',
	Name        => 'http_im_in',
	Description => 'Handles HTTP messages.',
	Author      => 'Cerone Kirsle',
	Created     => '5:21 PM 12/6/2004',
	Updated     => '5:21 PM 12/6/2004',
	Version     => '1.0',
};