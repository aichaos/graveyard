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
# AIM Handler: aim_chat_buddy_in
# Description: Called when a buddy (in chat) enters the room.

sub aim_chat_buddy_in {
	# Get variables from the server.
	my ($aim,$client,$chat,$data) = @_;

	my $screenname = $aim->screenname();
	my $time = localtime();

	# Format our screenname.
	$sn = lc($screenname);
	$sn =~ s/ //g;

	# Get the room name.
	my $room = $chat->name();
	$room = lc($room);
	$room =~ s/ //g;

	# If they weren't marked, add them.
	if (!exists $chaos->{$sn}->{_chats}->{$room}->{users}->{$client}) {
		$chaos->{$sn}->{_chats}->{$room}->{users}->{$client} = 1;

		# Only greet them if the join timeout has expired.
		if (time > $chaos->{$sn}->{_chats}->{$room}->{timeout}) {
			# Get our font.
			my $font = get_font ($sn, "AIM");

			# Chat welcome message.
			my $welcome = $font . "Welcome to chat, $client! :-) The current "
				. "topic is: $chaos->{_data}->{aim}->{chats}->{$room}->{topic}.";
			$welcome =~ s/\'/\\'/g;

			# Send the message.
			&dosleep (3);
			$aim->chat_send ($chat, $welcome);
		}

		print "ChaosAIM: $client has joined the room.\n"
			. "\tRoom Name: " . $chat->name() . "\n"
			. "\tScreenName: $screenname\n\n";
	}
}
1;