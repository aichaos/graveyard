#      .   .               <Leviathan>
#     .:...::     Command Name // !sendim
#    .::   ::.     Description // Cross-messenger SendIM.
# ..:;;. ' .;;:..        Usage // !sendim <username> [(messenger)]: <message>
#    .  '''  .     Permissions // Public.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub sendim {
	my ($self,$client,$msg) = @_;

	my ($listener,$nick) = split(/\-/, $client, 2);

	# See if the sender's listener is supported.
	my $supported = 0;
	if ($listener =~ /^(aim|msn)$/i) {
		$supported = 1;
	}

	# Create the footer text.
	my $footer = "To reply, type " . $chaos->{config}->{command}
		. "sendim $nick ($listener): message to send";
	if ($supported == 0) {
		$footer = "The message was sent from a medium that this command "
			. "does not support; you cannot send a response.";
	}

	# Must be a message.
	if (length $msg > 0) {
		$msg =~ s/\&lt\;/</ig;
		$msg =~ s/\&gt\;/>/ig;
		$msg =~ s/\&amp\;/&/ig;
		$msg =~ s/\&quot\;/"/ig;
		$msg =~ s/\&apos\;/'/ig;

		# Get data from the message.
		my ($temp,$what) = split(/:/, $msg, 2);
		my ($to,$messenger) = split(/\s+\(/, $temp, 2);

		$messenger = uc($messenger);
		$messenger =~ s/ //g;
		$messenger =~ s/[^A-Za-z0-9]//ig;

		return "You must provide a username to send a message to." if length $to == 0;
		return "You must provide a message to send." if length $what == 0;
		if ($to =~ /\((.*?)\)$/i && length $messenger == 0) {
			my $wanted = $1;
			return "Please make sure you put a space between the username and the messenger. "
				. "If the user truly does have a \"($wanted)\" at the end of their username, "
				. "then include their messenger after their username... with a space, of course.\n\n"
				. "(*) Good:\n"
				. "!sendim aimuser (AIM): Hello!\n"
				. "!sendim ircadmin (IRC): Hello!\n"
				. "(*) Bad:\n"
				. "!sendim aimuser(AIM): Hello!\n"
				. "!sendim ircadmin(IRC): Hello!\n\n"
				. "Make sure you have the space between the username and their messenger!";
		}

		# Listener to send to.
		my $l = $messenger;
		$l = $listener if length $l == 0;

		# Don't send to blocked users or warners.
		return "$to ($l) is blocked, I cannot send a message." if &isBlocked("$l\-$to");
		return "$to ($l) is on the warners list, I will not send a message." if &isWarner("$l\-$to");

		my $reply;

		# If we have a messenger...
		if (length $messenger > 0) {
			# See if this is a valid messenger.
			if ($messenger =~ /^(aim|msn)$/i) {
				# Find an available bot for this messenger.
				my $avail = 0;
				my $medium;
				foreach my $key (keys %{$chaos->{bots}}) {
					if ($chaos->{bots}->{$key}->{listener} eq $messenger) {
						$avail = 1;
						$medium = $key;
						last;
					}
				}

				# If there's an available bot...
				if ($avail == 1) {
					# Send an IM through this bot.
					if ($messenger eq "AIM") {
						# Get the AIM font.
						my ($font,$emo) = &get_font ($medium,'AIM');

						$reply = $font . "Message from $nick ($listener): $what<br><br>"
							. "$footer";

						# Queue it.
						$to =~ s/\'/\\'/ig;
						$reply =~ s/\'/\\'/ig;
						&queue ($medium,3,"\$chaos->{bots}->{'$medium'}->{client}->send_im ('$to','$reply');");

						# Return the response.
						return "I have attempted to send a message to $to using the AIM bot $medium. "
							. "I cannot determine if the message has been sent successfully.";
					}
					elsif ($messenger eq "MSN") {
						my ($font,$color,$style) = &get_font ($medium,'MSN');
						$reply = "Message from $nick ($listener): $what\n\n"
							. "$footer";

						# Send the message.
						$chaos->{bots}->{$medium}->{client}->call ($to,$reply,
							Font   => $font,
							Color  => $color,
							Effect => $style,
						);

						return "I have attempted to send a message to $to using the MSN bot $medium. "
							. "I cannot determine if the message was sent successfully.";
					}
					else {
						return "Unknown error.";
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
			# Just send another local call.
			my $sn;
			$sn = $self->screenname() if $listener eq "AIM";
			$sn = $self->{Msn}->{Handle} if $listener eq "MSN";
			$sn = lc($sn);
			$sn =~ s/ //g;

			$footer = "To reply, type " . $chaos->{config}->{command}
				. "sendim $nick: message to send";

			if ($listener eq "AIM") {
				# Get the AIM font.
				my ($font,$emo) = &get_font ($sn,"AIM");

				$reply = $font . "Message from $nick: $what<br><br>"
					. "$footer";

				# Queue it.
				$to =~ s/\'/\\'/ig;
				$reply =~ s/\'/\\'/ig;
				&queue ($sn,3,"\$chaos->{bots}->{'$sn'}->{client}->send_im ('$to','$reply');");

				return "I have attempted to send a message to $to. I cannot determine if it has "
					. "been sent successfully.";
			}
			elsif ($listener eq "MSN") {
				my ($font,$color,$style) = &get_font ($sn,'MSN');

				$reply = "Message from $nick: $what\n\n"
					. "$footer";

				$chaos->{bots}->{$sn}->{client}->call ($to,$reply,
					Font   => $font,
					Color  => $color,
					Effect => $style,
				);

				return "I have attempted to send a message to $to. I cannot determine if it has "
					. "been sent successfully.";
			}
			else {
				return "Unknown error.";
			}
		}
	}
	else {
		return "To send a message, the format is:\n"
			. "!sendim <lt>username<gt> [(messenger)]: <lt>message<gt>\n\n"
			. "Example: Send message to somebody on your messenger\n"
			. "!sendim ascreenname: hello there!\n"
			. "Example: Send message to somebody on different messenger\n"
			. "!sendim username (AIM): hello there!";
	}
}
{
	Category    => 'Fun Stuff',
	Description => 'Cross-messenger SendIM.',
	Usage       => '!sendim <username> [(messenger)]: <message>',
	Listener    => 'AIM,MSN',
};