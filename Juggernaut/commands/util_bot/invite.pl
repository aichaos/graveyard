#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !invite
#    .::   ::.     Description // Invite another MSN user into the conversation.
# ..:;;. ' .;;:..        Usage // !invite <email>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // MSN
#     :     :        Copyright // 2004 Chaos AI Technology

sub invite {
	my ($self,$client,$msg,$listener) = @_;

	# Get the username.
	my $sn;
	$sn = $self->{Msn}->{Handle} if $listener eq "MSN";
	$sn = $self->screenname() if $listener eq "AIM";
	$sn = lc($sn);
	$sn =~ s/ //g;

	# This command requires MSN.
	if ($listener eq "MSN") {
		# See if there is a user.
		if (length $msg > 0) {
			$msg = lc($msg);
			$msg =~ s/ //g;

			my $sock = $self->getID;

			# Shut up.
			$chaos->{$sn}->{_shutup}->{$sock} = 1;

			# Send confirmation.
			$self->sendmsg ("I will attempt to invite $msg into this conversation. If they do not "
				. "join, they have either blocked me or have security settings denying them "
				. "access to this conversation.\n\n"
				. "Furthermore, I will not talk during "
				. "your conversation.",
				Font => 'Verdana',
				Color => '000000',
				Style => 'B',
			);

			# Invite them.
			$self->invite ($msg) or return "Error: Could not invite user.";

			# Return the response.
			return "<noreply>";
		}
		else {
			return "You must give me an e-mail address to invite to this conversation.\n\n"
				. "!invite <lt>e-mail\@domain.com<gt>";
		}
	}
	elsif ($listener eq "AIM") {
		# See if there is a screenname.
		if (length $msg > 0) {
			$msg = lc($msg);
			$msg =~ s/ //g;

			# Must be in chat.
			return "This command is only available in AIM chat rooms." if
				$chaos->{$sn}->{current_user}->{in_chat} != 1;

			my $chat = $chaos->{$sn}->{current_user}->{chat};

			# Send the chat invite.
			#$self->chat_invite ($chat,"Invitation sent from $client to join chat.",$msg);

			# Return the response.
			return "There are bugs with this command and it is temporarily suspended.";
		}
		else {
			return "You must give me a screenname to invite to this chat.";
		}
	}
	else {
		return "Only MSN Messenger supports multiple person conversations.";
	}
}

{
	Category => 'Bot Utilities',
	Description => 'Invites a User to the MSN or AIM chat room.',
	Usage => '!invite <username>',
	Listener => 'AIM,MSN',
};