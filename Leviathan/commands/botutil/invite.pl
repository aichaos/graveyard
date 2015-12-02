#      .   .               <Leviathan>
#     .:...::     Command Name // !invite
#    .::   ::.     Description // Invites somebody to the conversation.
# ..:;;. ' .;;:..        Usage // !invite
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // MSN
#     :     :        Copyright // 2005 AiChaos Inc.

sub invite {
	my ($self,$client,$msg) = @_;

	my ($listener,$nick) = split(/\-/, $client, 2);

	# Only applies to MSN.
	if ($listener eq 'MSN') {
		# Message must exist.
		if (length $msg > 0) {
			# Invite the user.
			return "I only need the e-mail address of the person to invite; "
				. "this command is for MSN only and therefore the messenger "
				. "is implied. For example:\n\n"
				. "!invite user\@domain.com" if $msg =~ /^msn\-/i;

			$self->invite ($msg);

			return "I have attempted to invite $msg to this conversation. If he "
				. "does not join, he may be offline, or may have blocked me.";
		}
		else {
			return "Send me a user\'s e-mail address when using this command:\n\n"
				. "!invite user\@domain.com";
		}
	}
	else {
		return "This command only applies to MSN.";
	}
}

{
	Category => 'Bot Utilities',
	Description => 'Invites somebody to the conversation.',
	Usage => '!invite <MSN e-mail address>',
	Listener => 'MSN',
};