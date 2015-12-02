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
# AIM Handler: chat_buddy_in
# Description: Called when a user joins a chat room.

sub aim_chat_buddy_in {
	my ($aim,$client,$chat,$data) = @_;

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

	# If they weren't marked, add them.
	if (!exists $chaos->{bots}->{$sn}->{_chats}->{$room}->{users}->{$client}) {
		$chaos->{bots}->{$sn}->{_chats}->{$room}->{users}->{$client} = 1;

		# Only greet them if the chat timeout has expired.
		if (time() > $chaos->{bots}->{$sn}->{_chats}->{$room}->{timeout}) {
			# Get our font.
			my ($font,$smile) = &get_font ($sn,"AIM");

			# Chat welcome message.
			my $welcome = $font . "Welcome to chat, $client! :-) The current topic "
				. "is: $chaos->{data}->{aim}->{chats}->{$room}->{topic}.";

			if (length $smile > 0) {
				$welcome =~ s~o:\-\)~<font sml=\"$smile\">o:\-\)<\/font>~ig;
				$welcome =~ s~:\-\)~<font sml=\"$smile\">:\-\)<\/font>~ig;
				$welcome =~ s~:\)~<font sml=\"$smile\">:\)<\/font>~ig;
				$welcome =~ s~:\-d~<font sml=\"$smile\">:\-D<\/font>~ig;
				$welcome =~ s~:\-p~<font sml=\"$smile\">:\-p<\/font>~ig;
				$welcome =~ s~:\-\\~<font sml=\"$smile\">:\-\\<\/font>~ig;
				$welcome =~ s~:\-\/~<font sml=\"$smile\">:\-\/<\/font>~ig;
				$welcome =~ s~:\-\!~<font sml=\"$smile\">:\-\!<\/font>~ig;
				$welcome =~ s~:\-\$~<font sml=\"$smile\">:\-\$<\/font>~ig;
				$welcome =~ s~:\-\[~<font sml=\"$smile\">:\-\[<\/font>~ig;
				$welcome =~ s~=\-o~<font sml=\"$smile\">=\-o<\/font>~ig;
				$welcome =~ s~\;\-\)~<font sml=\"$smile\">\;\-\)<\/font>~ig;
				$welcome =~ s~\;\)~<font sml=\"$smile\">\;\)<\/font>~ig;
				$welcome =~ s~:\'\(~<font sml=\"$smile\">:\'\(<\/font>~ig;
				$welcome =~ s~>:o~<font sml=\"$smile\">&gt;:o<\/font>~ig;
			}


			$welcome =~ s/\'/\\'/g;

			# Save this chat object.
			$chaos->{bots}->{$sn}->{_chats}->{$room}->{object} = $chat;

			# Enqueue the message.
			&queue ($sn,3,"\$chaos->{bots}->{$sn}->{client}->chat_send ("
				. "\$chaos->{bots}->{$sn}->{_chats}->{$room}->{object}, '$welcome');");
		}

		print "$time\n"
			. "ChaosAIM: $client has joined the room.\n"
			. "\tRoom Name: " . $chat->name() . "\n"
			. "\tScreenName: $screenname\n\n";
	}
}
{
	Type        => 'handler',
	Name        => 'aim_chat_buddy_in',
	Description => 'Called when somebody joins the chat room.',
	Author      => 'Cerone Kirsle',
	Created     => '2:28 PM 11/20/2004',
	Updated     => '2:28 PM 11/20/2004',
	Version     => '1.0',
};