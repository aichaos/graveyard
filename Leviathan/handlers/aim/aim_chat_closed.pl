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
# AIM Handler: chat_closed
# Description: Called when the chat room is closed.

sub aim_chat_closed {
	my ($aim,$chat,$error) = @_;

	# Get some data.
	my $screenname = $aim->screenname();
	my $time = &get_timestamp();

	print "$time\n"
		. "ChaosAIM: Chatroom Error: $error\n"
		. "\tRoom: " . $chat->name() . "\n"
		. "\tScreenName: $screenname\n"
		. "\tYou have been disconnected from chat.\n\n";
}
{
	Type        => 'handler',
	Name        => 'aim_chat_closed',
	Description => 'Called when the chat room is closed.',
	Author      => 'Cerone Kirsle',
	Created     => '2:36 PM 11/20/2004',
	Updated     => '2:36 PM 11/20/2004',
	Version     => '1.0',
};