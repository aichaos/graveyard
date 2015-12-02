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
# AIM Handler: aim_chat_im_in
# Description: Handles incoming chat messages.

sub aim_chat_im_in {
	# Get variables from the server.
	my ($aim,$client,$chat,$msg) = @_;

	# Get this user's profile.
	&profile_get ($client,'AIM');

	# Cut off comment tags.
	$msg =~ s/<\!\-\-//ig;
	$msg =~ s/\-\->//ig;

	my $screenname = $aim->screenname();
	$screenname = lc($screenname);
	$screenname =~ s/ //g;
	my $time = localtime();

	# Format the client's screenname.
	$client = lc($client);
	$client =~ s/ //g;

	# Get the room name.
	my $room = $chat->name();
	my $lr = lc($room);
	$lr =~ s/ //g;

	# Make sure we aren't them.
	my $sn = $screenname;
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Get our name.
	my $name = $chaos->{$sn}->{data}->{name};
	$name = lc($name);
	$name =~ s/ //g;

	if ($client ne $sn) {
		# Format the message for HTML.
		$msg =~ s/<(.|\n)+?>//g;

		# Check for commands.
		my @words = split(/\s+/, $msg);
		my $char = $chaos->{_system}->{config}->{commandchar} || '!';
		foreach my $key (keys %{$chaos->{_system}->{commands}}) {
			my $current = $key;

			my $cmd = $char . $current;
			$words[0] = lc($words[0]);
			if ($words[0] eq "$cmd") {
				# It's a command.
				$msg = "$sn $msg";
			}
		}

		# See if they're talking directly to the bot.
		if ($msg =~ /^($sn|$name)/i || $msg =~ /($sn|$name)$/i) {
			if ($msg =~ /^($sn|$name)/i) {
				$msg =~ s/$sn //ig;
				$msg =~ s/$sn//ig;
				$msg =~ s/$name //ig;
				$msg =~ s/$name//ig;
			}
			if ($msg =~ /($sn|$name)$/i) {
				$msg =~ s/ $sn//ig;
				$msg =~ s/$sn//ig;
				$msg =~ s/ $name//ig;
				$msg =~ s/$name//ig;
			}

			# Save the chat object.
			$chaos->{$screenname}->{current_user}->{in_chat} = 1;
			$chaos->{$screenname}->{current_user}->{chat} = $chat;

			# Save an original copy.
			my $omsg = $msg;

			# See if this is a "built-in" chat command.
			if ($msg eq "leave") {
				# If they have the power to...
				my $chatdepart;
				if ($chaos->{$screenname}->{_chats}->{$lr}->{leave} == 1) {
					if (isAdmin($client,"AIM")) {
						# Leave the chatroom.
						$chatdepart = "<body bgcolor=\"black\">"
							. "<font face=\"Verdana\" size=\"2\" color=\"\#FFFF00\">"
							. "Good-bye, room! :-(</font></body>";
						&dosleep(2);
						$aim->chat_send ($chat, $chatdepart);
						&dosleep(2);
						$chat->part();
						return 1;
					}
					else {
						$chatdepart = "<body bgcolor=\"black\">"
							. "<font face=\"Verdana\" size=\"2\" color=\"\#FFFF00\">"
							. "This room is reserved and only an Admin can "
							. "banish me from it.</font></body>";
						&dosleep(2);
						$aim->chat_send ($chat, $chatdepart);
						return 1;
					}
				}
				else {
					# Leave the chatroom.
					$chatdepart = "<body bgcolor=\"black\">"
						. "<font face=\"Verdana\" size=\"2\" color=\"\#FFFF00\">"
						. "Good-bye, room! :-(</font></body>";
					&dosleep;
					$aim->chat_send ($chat, $chatdepart);
					&dosleep;
					$chat->part();
					return 1;
				}
			}
			elsif ($msg =~ /^topic/i) {
				# Setting/Viewing the topic.
				my ($void,$nt) = split(/\s+/, $msg, 2);

				my $topicr;

				if (length $nt > 0) {
					if (isAdmin($client,"AIM")) {
						$chaos->{_data}->{aim}->{chats}->{$lr}->{topic} = $nt;

						$topicr = "<body bgcolor=\"black\">"
							. "<font face=\"Verdana\" size=\"2\" color=\"\#00FF00\">"
							. "I have updated the chat topic.</font></body>";
						&dosleep(2);
						$aim->chat_send ($chat, $topicr);
					}
					else {
						$topicr = "<body bgcolor=\"black\">"
							. "<font face=\"Verdana\" size=\"2\" color=\"\#00FF00\">"
							. "Only an Admin can change the topic here.</font></body>";
						&dosleep(2);
						$aim->chat_send ($chat, $topicr);
					}
				}
				else {
					$topicr = "<body bgcolor=\"black\">"
						. "<font face=\"Verdana\" size=\"2\" color=\"\#00FF00\">"
						. "The current topic is: "
						. "$chaos->{_data}->{aim}->{chats}->{$lr}->{topic}</font></body>";
					&dosleep(2);
					$aim->chat_send ($chat, $topicr);
				}
				return 1;
			}

			# Send this to the input handler.
			my $reply = on_im ($aim,$screenname,$client,$msg,$omsg,"AIM");

			my @out = split(/\<\:\>/, $reply);

			# See if they're muted.
			if ($chaos->{_users}->{$client}->{mute} == 0) {
				# Send this reply if the these conditions aren't met.
				if ($reply !~ /<notcommand>/i && $reply !~ /<noreply>/i && $reply !~ /<blocked>/i) {
					foreach my $send (@out) {
						if ($send !~ /<font/i) {
							my $font = get_font ($screenname, "AIM");
							$send = $font . $send;
						}

						# Sleep a bit and then send.
						&dosleep(3);
						$aim->chat_send ($chat, $send, 1);
					}
				}
			}
			else {
				$reply = "noreply (muted)";
			}
		}
		else {
			# If it's a trigger...
			if (-e "$chaos->{$screenname}->{chattriggers}" == 1) {
				# Get the font.
				my $font = get_font ($screenname,"AIM");

				# Get this user's name.
				my $nickname = $chaos->{_users}->{$client}->{name} or &profile_get ($client,$listener);
				$nickname = $chaos->{_users}->{$client}->{name} unless defined $nickname;

				# If the nickname's a screenname, remove numbers.
				$nickname =~ s/[0-9]//ig;

				# Get dates and times.
				my $local_date = &get_date ('local','<day_name>, <month_name> <day_month> <year_full>');
				my $local_time = &get_date ('local','<hour_12>:<min>:<secs> <etc>');
				my $gm_date = &get_date ('gm','<day_name>, <month_name> <day_month> <year_full>');
				my $gm_time = &get_date ('gm','<hour_12>:<min>:<secs> <etc>');

				open (TRIG, "$chaos->{$screenname}->{chattriggers}");
				my @trig = <TRIG>;
				close (TRIG);

				chomp @trig;

				foreach my $line (@trig) {
					my ($match,$out) = split(/===/, $line, 2);
					my @outs = split(/\|/, $out);

					if ($msg =~ /$match/i) {
						$reply = $outs [ int(rand(scalar(@outs))) ];

						$reply =~ s/<client>/$client/ig;
						$reply =~ s/<screenname>/$screenname/ig;
						$reply =~ s/<local\-date>/$local_date/ig;
						$reply =~ s/<local\-time>/$local_time/ig;
						$reply =~ s/<gm\-date>/$gm_date/ig;
						$reply =~ s/<gm\-time>/$gm_time/ig;
						$reply =~ s/<name>/$nickname/ig;

						# Insert the font.
						$sending = $font . $reply;

						&dosleep(3);
						$aim->chat_send ($chat, $sending, 1);

						print "$time\n"
							. "<From Chat: $room>\n"
							. "[$client] $msg\n"
							. "[$screenname] $reply\n\n";

						return 1;
					}
				}

				print "$time\n"
					. "<From Chat: $room>\n"
					. "[$client] $msg\n\n";
			}
			else {
				print "$time\n"
					. "<From Chat: $room>\n"
					. "[$client] $msg\n\n";
			}
		}
	}
}
1;