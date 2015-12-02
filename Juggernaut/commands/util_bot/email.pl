#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !email
#    .::   ::.     Description // Send e-mail through the bot.
# ..:;;. ' .;;:..        Usage // !email <to> <message>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub email {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure they have a command body.
	if ($msg) {
		# Get the e-mail address.
		my ($email,$msg) = split(/ /, $msg, 2);

		# Make sure the e-mail is formatted right.
		my $format = 0;

		if ($email =~ /(.*)\@(.*)/) {
			if ($2 =~ /\./) {
				$format = 1;
			}
		}

		# If it's formatted and there's a message.
		if ($format == 1 && $msg) {
			# Use the Mail::Sendmail module.
			use Mail::Sendmail;

			my %mail;

			# The SMTP server to use.
			$mail{Smtp} = $chaos->{_system}->{config}->{emailserver} || 'localhost';

			# E-Mail Information
			my $name = $chaos->{_users}->{$client}->{name};

			$mail{From} = $chaos->{_system}->{config}->{emailfrom} || 'juggernaut@aichaos.com';
			$mail{To} = "$email";
			$mail{Subject} = $chaos->{_system}->{config}->{emailsubject} || 'Message from CKS Juggernaut';
			$mail{Message} = "From: $name <$client>\n\n"
				. "$msg\n\n"
				. "----------------------------------\n"
				. "This e-mail was sent to you through a bot named CKS Juggernaut, built "
				. "by Chaos AI Technology. Please note that this e-mail was NOT sent from "
				. "Chaos AI Technology and that we take no responsibility for the content "
				. "of this message.\n\n"
				. "http://www.aichaos.com/";

			# Send the e-mail.
			my $success = 0;
			if (Mail::Sendmail::sendmail (%mail)) {
				print "CKS // The E-Mail was Sent Successfully.";
				$reply = "The e-mail has been sent successfully.";
				$success = 1;
			}
			else {
				my $err = $Mail::Sendmail::error;
				print "CKS // The E-Mail was Not Sent Successfully.";
				$reply = "The e-mail could not be sent. Details:\n\n"
					. "$err";
			}

			# Save this e-mail.
			if ($success == 1) {
				open (LOGS, ">>./data/emails.txt");
				print LOGS "From: $name <$listener\-$client>\n"
					. "To: $email\n\n"
					. "$msg\n\n"
					. "=================================\n\n";
				close (LOGS);
			}
		}
		else {
			$reply = "Malformed e-mail or missing message. The correct format is:\n\n"
				. "!email address\@domain.tld message";
		}
	}
	else {
		$reply = "E-Mail Command:\n\n"
			. "!email address\@domain.tld message";
	}

	return $reply;
}

{
	Category => 'Bot Utilities',
	Description => 'Send An E-Mail Through Me',
	Usage => '!email <to> <message>',
	Listener => 'All',
};