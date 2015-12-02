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
# AIM Handler: chat_buddy_out
# Description: Called when a user exits a chat room.

sub aim_chat_buddy_out {
	my ($aim,$client,$chat) = @_;

	# Get some data.
	my $screenname = $aim->screenname();
	my $time = &get_timestamp();

	# Format our screenname.
	my $sn = lc($screenname);
	$sn =~ s/ //g;

	# Get the room name.
	my $room = $chat->name();
	$room = lc($room);
	$room =~ s/ //g;

	# Delete their existence in this room.
	delete $chaos->{bots}->{$sn}->{_chats}->{$room}->{users}->{$client};

	print "$time\n"
		. "ChaosAIM: $client has left the room.\n"
		. "\tRoom: " . $chat->name() . "\n"
		. "\tScreenName: $screenname\n\n";
}
{
	Type        => 'handler',
	Name        => 'aim_chat_buddy_out',
	Description => 'Called when somebody exits the chat room.',
	Author      => 'Cerone Kirsle',
	Created     => '2:35 PM 11/20/2004',
	Updated     => '2:35 PM 11/20/2004',
	Version     => '1.0',
};