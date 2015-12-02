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
# AIM Handler: aim_chat_joined
# Description: Called when a chatroom has been joined.

sub aim_chat_joined {
	# Get variables from the server.
	my ($aim,$room,$chat) = @_;

	my $screenname = $aim->screenname();
	my $time = localtime();

	my $sn = lc($screenname);
	$sn =~ s/ //g;

	my $chan = lc($room);
	$chan =~ s/ //g;

	# Print this invitation.
	print "ChaosAIM: Entered room $room\n"
		. "\tScreenName: $screenname\n";

	# Make a greet-users timeout so the bot won't say hi
	# to everybody already IN the room.
	$chaos->{$sn}->{_chats}->{$chan}->{timeout} = (time + 120);

	# Send a message to the room.
	my $font = get_font ($screenname,"AIM");

	$room = $chat->name();
	$room = lc($room);
	$room =~ s/ //g;
	if (!exists $chaos->{_data}->{aim}->{chats}->{$room}->{topic}) {
		$chaos->{_data}->{aim}->{chats}->{$room}->{topic} = "General";
	}

	&dosleep (3);
	$aim->chat_send ($chat, "$font" . 'Hello room! :-)');
}
1;