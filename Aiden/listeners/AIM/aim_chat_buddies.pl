# Chat buddies in/out.

sub aim_chat_buddy_in {
	my ($aim,$user,$chat,$data) = @_;

	print &timestamp . "\n"
		. "$user has entered chat " . $chat->name . ".\n\n";
}
sub aim_chat_buddy_out {
	my ($aim,$user,$chat) = @_;

	print &timestamp . "\n"
		. "$user has left chat " . $chat->name . "$chat.\n\n";
}
1;