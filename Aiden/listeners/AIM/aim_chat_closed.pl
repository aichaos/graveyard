# Chat IM's.

sub aim_chat_closed {
	my ($aim,$chat,$error) = @_;

	my $sn = $aim->screenname();
	print &timestamp . "\n"
		. "AidenAIM: $sn ejected from chat: $error\n\n";
}
1;