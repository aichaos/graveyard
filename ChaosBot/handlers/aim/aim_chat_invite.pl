# AIM Handler: chat_invite
# Handles incoming chat invitations.

sub aim_chat_invite {
	# Get server arguments from the shift.
	my ($aim,$client,$msg,$chat,$chaturl) = @_;

	my $time = localtime();

	my $screenname = $aim->screenname();

	print "$time\n";
	print "ChaosAIM: $screenname has been invited to a chat room:\n";
	print "ChaosAIM: Invitation Sender: $client\n";
	print "ChaosAIM: Message: $msg\n";
	print "ChaosAIM: Chatroom Name: $chat\n";
	print "ChaosAIM: Chat URL: $chaturl\n";

	$aim->chat_accept($chaturl);

	print "ChaosAIM: Invitation accepted. Joining room $chat.\n\n";
}
1;