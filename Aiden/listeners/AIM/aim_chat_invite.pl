# Chat IM's.

sub aim_chat_invite {
	my ($aim,$user,$msg,$chat,$url) = @_;

	my $sn = $aim->screenname;

	print &timestamp . "\n"
		. "AidenAIM: Received chat invitation\n"
		. "\tTo: $sn\n"
		. "\tFrom: $user\n"
		. "\tMsg: $msg\n"
		. "\tRoom: $chat\n";

	$user = lc($user);
	$user =~ s/ //g;
	my $client = join('-','AIM',$user);

	# Only accept from master.
	if (&isMaster($client)) {
		print "Accepting invitation from master.\n\n";
		$aim->chat_accept ($url);
	}
	else {
		print "Denying invitation.\n\n";
		$aim->chat_decline ($url);
	}
}
1;