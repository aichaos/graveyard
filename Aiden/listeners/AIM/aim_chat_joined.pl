# Chat IM's.

sub aim_chat_joined {
	my ($aim,$room,$chat) = @_;

	print &timestamp . "\n"
		. "AidenAIM: Joined room $chat\n\n";
}
1;