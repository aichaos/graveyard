#              ::.                   .:.
#               .;;:  ..:::::::.  .,;:
#                 ii;,,::.....::,;;i:
#               .,;ii:          :ii;;:
#             .;, ,iii.         iii: .;,
#            ,;   ;iii.         iii;   :;.
# .         ,,   ,iii,          ;iii;   ,;
#  ::       i  :;iii;     ;.    .;iii;.  ,,      .:;
#   .,;,,,,;iiiiii;:     ,ii:     :;iiii;;i:::,,;:
#     .:,;iii;;;,.      ;iiii:      :,;iiiiii;,:
#          :;        .:,,:..:,,.        .:;..
#           i.                  .        ,:
#           :;.         ..:...          ,;
#            ,;.    .,;iiiiiiii;:.     ,,
#             .;,  :iiiii;;;;iiiii,  :;:
#                ,iii,:        .,ii;;.
#                ,ii,,,,:::::::,,,;i;
#                ;;.   ...:.:..    ;i
#                ;:                :;
#                .:                ..
#                 ,                :
#  Subroutine: on_im
# Description: Handles all incoming messages.

sub on_im {
	# Get variables from the shift.
	my ($self,$sn,$client,$msg,$omsg,$listener) = @_;
	my $reply;

	# Make sure they're not flooding.
	my ($isFlood,$flood_reply) = &flood_check ($client,$listener,$msg);

	# If flooding...
	if ($isFlood) {
		# Return the reply.
		return $flood_reply;
	}

	# Remove trailing and leading spaces.
	$msg =~ s/^\s+//ig;
	$msg =~ s/\s+$//ig;

	# Socket Number.
	my $sock = $self->getID if $listener eq "MSN";

	# Check if maintenance mode is on.
	if ($chaos->{_system}->{maintain}->{on} == 1) {
		# Only Admins can continue using the bot.
		if (isAdmin($client,$listener) == 0) {
			return "<noreply>" if &isBlocked ($client,$listener);

			# Return the maintenance message.
			print localtime() . "\n"
				. "[$client] $msg\n"
				. "[$sn] $chaos->{_system}->{maintain}->{msg}\n\n";
			return "<auto>$chaos->{_system}->{maintain}->{msg}";
		}
	}

	# Do not reply if this is an Auto-Message.
	if ($msg =~ /^(automessage|auto message|auto\-message)/i) {
		return "<noreply>";
	}

	# Do not reply if this is an MSN client identification.
	if ($msg =~ /^client\-name/i) {
		return "<noreply>";
	}

	# Do not reply if this is an MSN custom emoticon.
	if ($msg =~ /msnobj/i) {
		return "<noreply>";
	}

	# Create a chat command variable.
	my $chat_cmd;

	# Format the listener to UPPERCASE.
	$listener = uc($listener);

	# Get this user's profile.
	&profile_get ($client,$listener);

	$sn = lc($sn);
	$sn =~ s/ //g;

	# Save this person's name as the last messenger.
	$chaos->{$sn}->{last_client} = $client;

	# Save this as the last overall message as well.
	$chaos->{_data}->{last_client} = "$client<>$sn";

	# Save this time as their last message's time.
	$chaos->{_users}->{$client}->{_active} = time();

	# See if this user is blocked or is on the warners list.
	my $warner = isWarner ($self,$client,$listener);
	my $block = isBlocked ($client,$listener);

	# If they're neither a warner nor blocked... continue.
	if ($warner == 0 && $block == 0) {
		# Compare this to a list of commands.
		my $is_command;
		($is_command,$reply) = isCommand ($self,$client,$msg,$listener);

		$chat_cmd = $is_command;

		# If it's not a command... continue.
		if ($is_command == 0) {
			# See if they're in a callback.
			if (exists $chaos->{_users}->{$client}->{callback}) {
				# Redirect them to this callback sub.
				my $callback = $chaos->{_users}->{$client}->{callback};
				$reply = &{$callback} ($self,$client,$msg,$listener);
			}
			else {
				# Skip this part if it's the chat.
				if ($chaos->{$sn}->{chat} eq $self || $chaos->{$sn}->{_shutup}->{$sock} == 1) {
					goto skipReply;
				}

				# Filter the message in all ways possible.
				$msg = filter ($msg);

				# Send this message to the brain.
				$reply = brain ($self,$client,$listener,$msg,$omsg,$sn);
			}
		}
	}
	else {
		# Return that they're blocked.
		print "CKS // Ignoring message from $client (blocked)\n"
			. "\tTheir Msg: $msg\n\n";
		return "<blocked>";
	}

	skipReply:

	# If they're muted, $reply = "noreply" thing.
	if ($chaos->{_users}->{$client}->{mute} == 1) {
		$reply = "<noreply--muted>";
	}

	# If they're in the MSN chat and aren't commanding.
	if ($chaos->{$sn}->{chat} eq $self || $chaos->{$sn}->{_shutup}->{$sock} == 1) {
		print "Debug // Chat_Cmd: $chat_cmd\n";
		if ($chat_cmd == 1 && $chaos->{$sn}->{_shutup}->{$sock} != 1) {
			# Only Admins can use this.
			if (isAdmin($client,$listener)) {
				# Allow this.
			}
			else {
				$reply = "<noreply--in chat>";
			}
		}
		elsif ($chat_cmd != 1) {
			$reply = "<noreply--in chat>";
		}
	}

	# Convert special codes.
	$reply =~ s/<lt>/&lt;/ig;
	$reply =~ s/<gt>/&gt;/ig;

	# Log this IM.
	&log_im ($client,$omsg,$sn,$reply,$listener);

	# If we support HTML, change \n to <br>.
	if ($listener eq "AIM") {
		$reply =~ s/\n/<br>/ig;
	}

	sendit:
	# Comments aren't sent.
	$reply =~ s/<\!\-\-(.*?)\-\->//ig;

	# Return the response.
	if ($listener eq "MSN") {
		return $reply;
	}
	elsif ($listener eq "AIM") {
		my $text = get_font ($sn,"AIM");
		return ($text . $reply);
	}
	elsif ($listener eq "IRC") {
		return $reply;
	}
	elsif ($listener eq "HTTP") {
		return $reply;
	}
	else {
		&panic ("Unknown listener recieved at on_im.pl.", 0);
		return $reply;
	}
}
1;