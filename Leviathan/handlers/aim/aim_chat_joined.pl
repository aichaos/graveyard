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
# AIM Handler: chat_joined
# Description: Called when you join a chat.

sub aim_chat_joined {
	my ($aim,$room,$chat) = @_;

	# Get some data.
	my $screenname = $aim->screenname();
	my $time = &get_timestamp();

	my $sn = lc($screenname);
	$sn =~ s/ //g;

	my $chan = lc($room);
	$chan =~ s/ //g;

	print "$time\n"
		. "ChaosAIM: Entered room $room\n"
		. "\tScreenName: $screenname\n\n";

	# Make a greet-users timeout so it won't say hi to everybody right away.
	$chaos->{bots}->{$sn}->{_chats}->{$chan}->{timeout} = (time() + 120);

	# Set the topic.
	if (!exists $chaos->{data}->{aim}->{chats}->{$chan}->{topic}) {
		$chaos->{data}->{aim}->{chats}->{$chan}->{topic} = 'General';
	}

	# Send a message to all users.
	my ($font,$smile) = &get_font ($sn,"AIM");
	my $msg = $font . "Hello room! :-)";
	# Filter in smileys.
	if (length $smile > 0) {
		$msg =~ s~o:\-\)~<font sml=\"$smile\">o:\-\)<\/font>~ig;
		$msg =~ s~:\-\)~<font sml=\"$smile\">:\-\)<\/font>~ig;
		$msg =~ s~:\)~<font sml=\"$smile\">:\)<\/font>~ig;
		$msg =~ s~:\-d~<font sml=\"$smile\">:\-D<\/font>~ig;
		$msg =~ s~:\-p~<font sml=\"$smile\">:\-p<\/font>~ig;
		$msg =~ s~:\-\\~<font sml=\"$smile\">:\-\\<\/font>~ig;
		$msg =~ s~:\-\/~<font sml=\"$smile\">:\-\/<\/font>~ig;
		$msg =~ s~:\-\!~<font sml=\"$smile\">:\-\!<\/font>~ig;
		$msg =~ s~:\-\$~<font sml=\"$smile\">:\-\$<\/font>~ig;
		$msg =~ s~:\-\[~<font sml=\"$smile\">:\-\[<\/font>~ig;
		$msg =~ s~=\-o~<font sml=\"$smile\">=\-o<\/font>~ig;
		$msg =~ s~\;\-\)~<font sml=\"$smile\">\;\-\)<\/font>~ig;
		$msg =~ s~\;\)~<font sml=\"$smile\">\;\)<\/font>~ig;
		$msg =~ s~:\'\(~<font sml=\"$smile\">:\'\(<\/font>~ig;
		$msg =~ s~>:o~<font sml=\"$smile\">&gt;:o<\/font>~ig;
	}
	$msg =~ s/\'/\\'/g;

	# Queue it.
	$chaos->{bots}->{$sn}->{_chats}->{$chan}->{object} = $chat;
	&queue ($sn,3,"\$chaos->{bots}->{$sn}->{client}->chat_send (\$chaos->{bots}->{$sn}->{_chats}->{$chan}->{object},"
		. "'$msg');");
}
{
	Type        => 'handler',
	Name        => 'aim_chat_joined',
	Description => 'Called when you join a chat.',
	Author      => 'Cerone Kirsle',
	Created     => '2:43 PM 11/20/2004',
	Updated     => '2:43 PM 11/20/2004',
	Version     => '1.0',
};