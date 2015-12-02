#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !sendim
#    .::   ::.     Description // Cross-messenger send IM command.
# ..:;;. ' .;;:..        Usage // !sendim <username> [(messenger)]-><message>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // AIM, MSN
#     :     :        Copyright // 2004 Chaos AI Technology

sub sendim {
	my ($self,$client,$msg,$listener) = @_;

	# Filter ASC things.
	$msg =~ s/\&lt\;/</ig;
	$msg =~ s/\&gt\;/>/ig;
	$msg =~ s/\&amp\;/&/ig;
	$msg =~ s/\&quot\;/"/ig;
	$msg =~ s/\&apos\;/'/ig;

	# See if they have a message.
	if (length $msg == 0) {
		return "To send a message, the format is:\n"
			. "!sendim <lt>username<gt> [(messenger)]-><lt>message<gt>\n\n"
			. "Example: Send message to somebody on your messenger\n"
			. "!sendim ascreenname->hello there!\n"
			. "Example: Send message to somebody on different messenger\n"
			. "!sendim username (AIM)->hello there!";
	}

	# Get some information from the message.
	my ($temp,$what) = split(/\-\>/, $msg, 2);
	my ($to,$messenger) = split(/\s+\(/, $temp, 2);

	$messenger = lc($messenger);
	$messenger =~ s/ //g;

	# Make the messenger alphanumeric only.
	$messenger =~ s/[^A-Za-z0-9 ]//ig;

	return "You must provide a username to send a message to." if length $to == 0;
	return "You must provide a message to send." if length $what == 0;
	if ($to =~ /\((.*?)\)$/i && length $messenger == 0) {
		my $wanted = $1;
		if ($wanted =~ /^(aim|msn|irc)$/i) {
			return "Please make sure you put a space between the username "
				. "and the messenger. If the user truly does have a "
				. "\"(" . uc($wanted) . ")\" at the end of their username, then "
				. "include their messenger after their username... with a space "
				. "of course.\n\n"
				. "(*) Good:\n"
				. "!sendim aimuser (AIM)->Hello!\n"
				. "!sendim ircadmin (IRC)->Hello!\n"
				. "(*) Bad:\n"
				. "!sendim aimuser(AIM)->Hello!\n"
				. "!sendim ircadmin(IRC)->Hello!\n\n"
				. "Make sure you have the space between the username and their messenger!";
		}
	}

	# Make sure the user is not blocked.
	my $l = uc($messenger) || uc($listener);
	print "Debug // \$l: $l\n";
	return "$to is blocked, I cannot send a message." if isBlocked ($to,$l);
	return "$to is on the warners list, I will not send a message." if isWarner ($self,$to,$l);

	print "Debug // To: $to\nWhat: $what\nMsgr: $messenger\n\n";

	my $reply;

	# If we have a messenger...
	if (length $messenger > 0) {
		# See if this is a valid messenger.
		if ($messenger eq "aim" || $messenger eq "msn") {
			# Find an available bot for this messenger.
			my $avail = 0;
			my $medium;
			foreach my $key (keys %{$chaos}) {
				if ($chaos->{$key}->{listener} eq $messenger) {
					$avail = 1;
					$medium = $key;
					last;
				}
			}

			# If we have an available bot...
			if ($avail == 1) {
				# Send an IM through this bot (or sleep a bit
				# for messengers with rate limits)

				if ($messenger eq "aim") {
					# Get the AIM font.
					my $font = get_font ($medium, "AIM");

					$reply = $font . "Message from $client ($listener): $what<br><br>"
						. "To reply, type " . $chaos->{_system}->{config}->{commandchar}
						. "sendim $client ($listener)->message to send";

					&dosleep(3);
					$chaos->{$medium}->{client}->send_im ($to,$reply);

					# Return the response.
					return "I have attempted to send a message to $to using "
						. "the AIM bot $medium. I cannot determine if the "
						. "message has been sent successfully.";
				}
				elsif ($messenger eq "msn") {
					$reply = "Message from $client ($listener): $what\n\n"
						. "To reply, type " . $chaos->{_system}->{config}->{commandchar}
						. "sendim $client ($listener)->message to send";

					$chaos->{$medium}->{client}->call ($to,$reply);

					return "I have attempted to send a message to $to using "
						. "the MSN bot $medium. I cannot determine if the "
						. "message has been sent successfully.";
				}
				else {
					return "Strangely I forgot what messenger you are on.";
				}
			}
			else {
				return "No available $messenger bot exists to complete your action.";
			}
		}
		else {
			return "I do not support messages being sent to that listener.";
		}
	}
	else {
		# Just another local call.
		my $screenname;
		$screenname = $self->screenname() if $listener eq "AIM";
		$screenname = $self->{Msn}->{Handle} if $listener eq "MSN";
		$screenname = lc($screenname);
		$screenname =~ s/ //g;

		if ($listener eq "AIM") {
			# Get the AIM font.
			my $aimfont = get_font ($screenname,"AIM");

			# Make sure the user is active.
			if (!exists $chaos->{_users}->{$to}->{_active} || time - $chaos->{_users}->{$to}->{_active} > 60) {
				return "That username has not sent me a message in the last 60 "
					. "seconds. It's a security precaution that I never am "
					. "the one to initiate a new conversation. Get your friend "
					. "to send me a message, and then you can send them a "
					. "message through me. :-)";
			}

			$reply = $aimfont . "Message from $client: $what<br><br>"
				. "To reply, type " . $chaos->{_system}->{config}->{commandchar}
				. "sendim $client->message to send";

			&dosleep;
			$chaos->{$screenname}->{client}->send_im ($to,$reply);

			# Return the response.
			return "I have attempted to send a message to $to. "
				. "I cannot determine if the "
				. "message has been sent successfully.";
		}
		elsif ($listener eq "MSN") {
			$reply = "Message from $client: $what\n\n"
				. "To reply, type " . $chaos->{_system}->{config}->{commandchar}
				. "sendim $client->message to send";

			$chaos->{$screenname}->{client}->call ($to,$reply);

			# Return the response.
			return "I have attempted to send a message to $to. "
				. "I cannot determine if the "
				. "message has been sent successfully.";
		}
		else {
			return "Strangely I didn't get your messenger name.";
		}
	}
}

{
	Category => 'Bot Utilities',
	Description => 'Cross-Messenger SendIM',
	Usage => '!sendim <username> [(messenger)]-><message>',
	Listener => 'AIM/MSN',
};