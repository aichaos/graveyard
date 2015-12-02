# Chat IM's.

sub aim_chat_im_in {
	my ($aim,$user,$chat,$msg) = @_;

	my $sn = &normalize($aim->screenname);

	$user = lc($user);
	$user =~ s/ //g;
	my $client = join('-','AIM',$user);

	# The bot's name.
	my $name = $aiden->{root}->{profile}->{name};
	$name = lc($name);
	$name =~ s/ //g;

	# Filter the message for HTML.
	$msg =~ s/<(.|\n)+?>//g;

	# Only respond if we're being addressed directly.
	if ($msg =~ /^$name (.*?)$/i || $msg =~ /^(.*?) $name$/i) {
		$msg = $1;

		my $bg = $aiden->{bots}->{$sn}->{font}->{background};
		my $font = $aiden->{bots}->{$sn}->{font}->{family};
		my $link = $aiden->{bots}->{$sn}->{font}->{link};
		my $color = $aiden->{bots}->{$sn}->{font}->{color};
		my $size = $aiden->{bots}->{$sn}->{font}->{size};

		# Copy the chat object.
		my $room = &normalize($chat->name);
		$aiden->{data}->{aimchat}->{$room} = $chat;

		# Built-in commands.
		if ($msg =~ /^leave$/i) {
			if (&isMaster($client)) {
				# Leave the room.
				my $send = "<html><body bgcolor=\"$bg\" link=\"$link\"><font face=\"$font\" color=\"$color\" size=\"$size\">"
					. "Goodbye everyone!</font></body></html>";

				# Enqueue this message.
				$send =~ s/\'/\\'/g;
				&queue ($sn,3,"\$aiden->{bots}->{'$sn'}->{client}->chat_send (\$aiden->{data}->{aimchat}->{$room},'$send');");
				&queue ($sn,3,"\$aiden->{data}->{aimchat}->{$room}->part;");
			}
			else {
				my $send = "<html><body bgcolor=\"$bg\" link=\"$link\"><font face=\"$font\" color=\"$color\" size=\"$size\">"
					. "You don't have permission to eject me from this room.</font></body></html>";

				# Enqueue this message.
				$send =~ s/\'/\\'/g;
				&queue ($sn,3,"\$aiden->{bots}->{'$sn'}->{client}->chat_send (\$aiden->{data}->{aimchat}->{$room},'$send');");
			}
		}
		else {
			# Get a reply.
			print "Chat Room: " . $chat->name() . "\n";
			my $reply = &on_im ('AIM',$aim,$client,$msg,$sn);

			# Send the reply.
			if ($reply ne '<noreply>') {
				my $send = "<html><body bgcolor=\"$bg\" link=\"$link\"><font face=\"$font\" color=\"$color\" size=\"$size\">"
					. "$reply</font></body></html>";

				# Enqueue this message.
				$send =~ s/\'/\\'/g;
				&queue ($sn,3,"\$aiden->{bots}->{'$sn'}->{client}->chat_send (\$aiden->{data}->{aimchat}->{$room},'$send');");
			}
		}
	}
	else {
		print "Chat Room: " . $chat->name() . "\n"
			. "AidenAIM: [$client] $msg\n\n";
	}
}
1;