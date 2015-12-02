#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !leave
#    .::   ::.     Description // Leave the conversation.
# ..:;;. ' .;;:..        Usage // !leave
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // MSN
#     :     :        Copyright // 2004 Chaos AI Technology

sub leave {
	my ($self,$client,$msg,$listener) = @_;

	my $sn;

	# This command requires MSN.
	if ($listener eq "MSN") {
		# Get the handle.
		$sn = $self->{Msn}->{Handle};
		$sn = lc($sn);
		$sn =~ s/ //g;

		# Leave the conversation.
		$self->sendmsg ("Goodbye, room! :-(",
			Font => 'Verdana',
			Color => '990000',
			Style => 'B',
		);

		sleep(1);

		$self->leave ();

		return '<noreply>';
	}
	elsif ($listener eq "AIM") {
		# Get the screenname.
		$sn = $self->screenname();
		$sn = lc($sn);
		$sn =~ s/ //g;

		# Must be in chat.
		if ($chaos->{$sn}->{current_user}->{in_chat} == 1) {
			my $chat = $chaos->{$sn}->{current_user}->{chat};
			my $room = $chat->name();
			my $lr = lc($room);
			$lr =~ s/ //g;

			my $chatdepart;

			if ($chaos->{$sn}->{_chats}->{$lr}->{leave} == 1) {
				if (isAdmin ($client,$listener)) {
					# Leave the room.
					$chatdepart = "<body bgcolor=\"#010101\">"
						. "<font face=\"Arial\" size=\"2\" color=\"#FFFF00\">"
						. "Good-bye, room! :-(</font></body>";
					&dosleep (2);
					$self->chat_send ($chat,$chatdepart);
					&dosleep (2);
					$chat->part();
					return "<noreply>";
				}
				else {
					return "This room is reserved and only an Admin may banish me from it.";
				}
			}
			else {
				# Leave the room.
				$chatdepart = "<body bgcolor=\"#010101\">"
					. "<font face=\"Arial\" size=\"2\" color=\"#FFFF00\">"
					. "Good-bye, room! :-(</font></body>";
				&dosleep (2);
				$self->chat_send ($chat,$chatdepart);
				&dosleep (2);
				$chat->part();
				return "<noreply>";
			}
		}
		else {
			return "This command can only be used in AIM chat.";
		}
	}
	else {
		return "Only MSN Messenger supports multiple person conversations.";
	}
}

{
	Category => 'Bot Utilities',
	Description => 'Leave the MSN Conversation',
	Usage => '!leave',
	Listener => 'MSN',
};