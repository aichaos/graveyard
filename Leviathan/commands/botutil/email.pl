#      .   .               <Leviathan>
#     .:...::     Command Name // !email
#    .::   ::.     Description // Send an e-mail through me!
# ..:;;. ' .;;:..        Usage // !email <address> <message to send>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub email {
	my ($self,$client,$msg) = @_;

	# E-Mail Rate Limit: 15 minutes between each e-mail.
	my $ratelimit = (60*15);
	if (exists $chaos->{clients}->{$client}->{_email_flood}) {
		my $sent = $chaos->{clients}->{$client}->{_email_flood};

		# If the rate limit has expired...
		if (time() - $sent > $ratelimit) {
			# Delete the key and continue.
			delete $chaos->{clients}->{$client}->{_email_flood};
		}
		else {
			# Tell them.
			my $left = time() - $sent;
			$left = int(($ratelimit - $left) / 60);
			return "E-Mail flood detected: please wait 15 minutes between each e-mail "
				. "you send. You can use this command again in "
				. "$left minutes.";
		}
	}

	# Required message data.
	my ($to,$message) = split(/\s+/, $msg, 2);

	return "You must include an e-mail address to send to!" unless length $to > 0;

	# If the e-mail address is correct...
	if ($to =~ /^(.*?)\@(.*?)/i) {
		# If the message is defined...
		if (length $message > 0) {
			# Send the message!
			use Mail::Sendmail;

			$message .= "\n\n"
				. "===========================================\n"
				. "      .   .       This e-mail was sent to you\n"
				. "     .:...::      through a bot called AiChaos\n"
				. "    .::   ::.     Leviathan. The e-mail was sent\n"
				. " ..:;;. ' .;;:..  by $client. AiChaos assumes no\n"
				. "    .  '''  .     responsibility by the content\n"
				. "     :;,:,;:      of this e-mail message.\n"
				. "     :     :\n\n"
				. "AiChaos, Inc. ~ http://www.aichaos.com/";

			# Create the e-mail.
			my %mail = (
				Smtp    => $chaos->{config}->{email}->{smtp},
				From    => $chaos->{config}->{email}->{from} || 'AiChaos Leviathan <leviathan@aichaos.com>',
				To      => $to,
				Subject => $chaos->{config}->{email}->{subject} || 'Message sent from AiChaos Leviathan.',
				Message => $message,
			);

			# Send the e-mail.
			if (Mail::Sendmail::sendmail(%mail)) {
				# Stop them from using this command again for 15 minutes.
				$chaos->{clients}->{$client}->{_email_flood} = time();
				return "The e-mail has been sent successfully.";
			}
			else {
				return "The e-mail could not be sent! Details:\n\n"
					. $Mail::Sendmail::error;
			}
		}
		else {
			return "You must include a message to send, i.e.\n\n"
				. "!email $to Hello there!";
		}
	}
	else {
		return "The e-mail address isn't properly formatted!";
	}
}

{
	Category => 'Bot Utilities',
	Description => 'Send an e-mail through me.',
	Usage => '!email <address> <message>',
	Listener => 'All',
};