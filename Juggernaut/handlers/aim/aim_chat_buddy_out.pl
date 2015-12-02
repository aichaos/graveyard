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
# AIM Handler: aim_chat_buddy_out
# Description: Called when a buddy (in chat) leaves the room.

sub aim_chat_buddy_out {
	# Get variables from the server.
	my ($aim,$client,$chat) = @_;

	my $screenname = $aim->screenname();
	my $time = localtime();

	my $sn = lc($screenname);
	$sn =~ s/ //g;

	# Get our room name (and format it)
	my $room = $chat->name();
	$room = lc($room);
	$room =~ s/ //g;

	# Delete their existence in this room.
	delete $chaos->{$sn}->{_chats}->{$room}->{users}->{$client};

	print "ChaosAIM: $client has left the room.\n"
		. "\tScreenName: $screenname\n\n";
}
1;