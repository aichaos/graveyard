# AIM Handler: chat_joined
# Handles incoming chat invitations.

sub aim_chat_joined {
	# Get server arguments from the shift.
	my ($aim,$chatname,$chat) = @_;

	my $time = localtime();

	my $screenname = $aim->screenname();

	print "$time\n";
	print "ChaosAIM: $screenname has joined chat $chatname.\n\n";

	$aim->chat_send ($chat, 'Hello room! :-)');
}
1;