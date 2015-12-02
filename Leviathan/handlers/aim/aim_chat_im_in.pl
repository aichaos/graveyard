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
# AIM Handler: chat_im_in
# Description: Handles instant messages in chat.

sub aim_chat_im_in {
	my ($aim,$client,$chat,$msg) = @_;

	# Get some data.
	my $screenname = $aim->screenname();
	my $time = &get_timestamp();

	# Format the user's name.
	$client = lc($client);
	$client =~ s/ //g;
	my $user = $client;
	$client = 'AIM-' . $client;

	# Get this user's info.
	&profile_get ($client);

	# Cut off comment tags.
	$msg =~ s/<\!\-\-//ig;
	$msg =~ s/\-\->//ig;

	# Get this room's name.
	my $room = $chat->name();
	my $lr = lc($room);
	$lr =~ s/ //g;

	# Make sure we aren't them.
	my $sn = lc($screenname);
	$sn =~ s/ //g;
	return if $user eq $sn;

	# Get our name.
	my $name = $chaos->{bots}->{$sn}->{_data}->{name};
	$name = lc($name);
	$name =~ s/ //g;

	# Remove HTML from the message.
	$msg =~ s/<(.|\n)+?>//ig;

	# See if they're talking directly to the bot.
	if ($msg =~ /^($sn|$name|leviathan)/i || $msg =~ /($sn|$name|leviathan)$/i) {
		if ($msg =~ /^($sn|$name|leviathan)/i) {
			$msg =~ s/^$sn //ig;
			$msg =~ s/^$sn//ig;
			$msg =~ s/^$name //ig;
			$msg =~ s/^$name//ig;
			$msg =~ s/^leviathan //ig;
			$msg =~ s/^leviathan//ig;
		}
		else {
			$msg =~ s/ $sn$//ig;
			$msg =~ s/$sn$//ig;
			$msg =~ s/ $name$//ig;
			$msg =~ s/$name$//ig;
			$msg =~ s/ leviathan//ig;
			$msg =~ s/leviathan//ig;
		}

		# Save an original copy of the message.
		my $omsg = $msg;

		# Built-in chat commands.
		if ($msg =~ /^leave$/i) {
			# Only if they have the power to.
			my $admin = &isAdmin($client);
			my $leave = 0;
			if ($admin) {
				# Leave.
				$leave = 1;
			}
			else {
				# Allowed to leave?
				if ($chaos->{bots}->{$sn}->{_chats}->{$lr}->{leave} == 1) {
					$leave = 0;
				}
				else {
					$leave = 1;
				}
			}

			# Allowed to leave?
			if ($leave == 1) {
				$chaos->{bots}->{$sn}->{temp}->{$lr} = $chat;

				# Are they blocked?
				if (&isBlocked ($client)) {
					&queue ($sn,2,"\$chaos->{bots}->{$sn}->{client}->chat_send (\$chaos->{bots}->{'$sn'}->{temp}->{'$lr'},"
						. "'<body bgcolor=#000000><font face=Arial size=2 color=#FFFF00>"
						. "You are blocked, I will not obey you.</font></body>',1);");
					return 1;
				}
				else {
					&queue ($sn,2,"\$chaos->{bots}->{$sn}->{client}->chat_send (\$chaos->{bots}->{'$sn'}->{temp}->{'$lr'},"
						. "'<body bgcolor=#000000><font face=Arial size=2 color=#FFFF00>"
						. "Good-bye, room! :-(</font></body>',1);");
					&queue ($sn,2,"\$chaos->{bots}->{'$sn'}->{temp}->{'$lr'}->part();");
				}
			}
			else {
				$chaos->{bots}->{$sn}->{temp}->{$lr} = $chat;
				&queue ($sn,2,"\$chaos->{bots}->{$sn}->{client}->chat_send (\$chaos->{bots}->{'$sn'}->{temp}->{'$lr'},"
					. "'<body bgcolor=#000000><font face=Arial size=2 color=#FFFF00>"
					. "This room is reserved; only an Admin can make me leave!</font></body>',1);");
			}
			return 1;
		}
		elsif ($msg =~ /^topic$/i) {
			# Return the topic.
			my ($font,$smile) = &get_font ($sn,'AIM');
			my $send = $font . "The current topic is: $chaos->{data}->{aim}->{chats}->{$lr}->{topic}";
			$send =~ s/\'/\\'/g;

			# Enqueue the message.
			$chaos->{bots}->{$sn}->{_chats}->{$room}->{object} = $chat;
			&queue ($sn,3,"\$chaos->{bots}->{$sn}->{client}->chat_send ("
				. "\$chaos->{bots}->{$sn}->{_chats}->{$lr}->{object}, '$send');");
			return 1;
		}
		elsif ($msg =~ /^topic (.*?)$/i) {
			my $set = $1;
			my ($font,$smile) = &get_font ($sn,'AIM');

			# Only Admins and higher.
			my $send = '';
			if (&isAdmin($client)) {
				$chaos->{data}->{aim}->{chats}->{$lr}->{topic} = $set;
				$send = $font . "The topic has been updated.";
			}
			else {
				$send = $font . "The topic can only be changed by Administrators.";
			}
			$send =~ s/\'/\\'/g;

			# Enqueue the message.
			$chaos->{bots}->{$sn}->{_chats}->{$room}->{object} = $chat;
			&queue ($sn,3,"\$chaos->{bots}->{$sn}->{client}->chat_send ("
				. "\$chaos->{bots}->{$sn}->{_chats}->{$lr}->{object}, '$send');");
			return 1;
		}


		# Get a reply.
		my $reply = &on_im ($aim,$sn,$client,$msg,$omsg);
		my @out = split(/<:>/, $reply);

		if (length $reply > 232) {
			&queue ($sn,2,"\$chaos->{bots}->{$sn}->{client}->chat_send (\$chaos->{bots}->{'$sn'}->{temp}->{'$lr'},"
				. "'<body bgcolor=#000000><font face=Arial size=2 color=#FFFF00>"
				. "My reply is too long to send over chat.</font></body>',1);");
			return 1;
		}

		# Not if they're muted.
		if ($chaos->{clients}->{$client}->{mute} == 0) {
			# Send if these aren't met.
			if ($reply !~ /<notcommand>/i && $reply !~ /<noreply>/i && $reply !~ /<blocked>/i) {
				foreach my $send (@out) {
					my ($font,$smile) = &get_font ($screenname, "AIM");
					if ($send !~ /<font/i) {
						$send = $font . $send;
					}

					# Filter in smileys.
					if (length $smile > 0) {
						$send =~ s~o:\-\)~<font sml=\"$smile\">o:\-\)<\/font>~ig; # o:-)
						$send =~ s~:\-\)~<font sml=\"$smile\">:\-\)<\/font>~ig;   # :-)
						$send =~ s~:\)~<font sml=\"$smile\">:\)<\/font>~ig;       # :)
						$send =~ s~:\-d~<font sml=\"$smile\">:\-D<\/font>~ig;     # :-D
						$send =~ s~:\-p~<font sml=\"$smile\">:\-p<\/font>~ig;     # :-P
						$send =~ s~:\-\\~<font sml=\"$smile\">:\-\\<\/font>~ig;   # :-\
						$send =~ s~:\-\/~<font sml=\"$smile\">:\-\/<\/font>~ig;   # :-/
						$send =~ s~:\-\!~<font sml=\"$smile\">:\-\!<\/font>~ig;   # :-!
						$send =~ s~:\-\$~<font sml=\"$smile\">:\-\$<\/font>~ig;   # :-$
						$send =~ s~:\-\[~<font sml=\"$smile\">:\-\[<\/font>~ig;   # :-[
						$send =~ s~=\-o~<font sml=\"$smile\">=\-o<\/font>~ig;     # =-o
						$send =~ s~\;\-\)~<font sml=\"$smile\">\;\-\)<\/font>~ig; # ;-)
						$send =~ s~\;\)~<font sml=\"$smile\">\;\)<\/font>~ig;     # ;)
						$send =~ s~:\'\(~<font sml=\"$smile\">:\'\(<\/font>~ig;   # :'(
						$send =~ s~:\(~<font sml=\"$smile\">:\-\(<\/font>~ig;     # :(
						$send =~ s~:\-\(~<font sml=\"$smile\">:\-\(<\/font>~ig;   # :(
						$send =~ s~8\-\)~<font sml=\"$smile\">8\-\)<\/font>~ig;   # 8-(
						$send =~ s~>:o~<font sml=\"$smile\">&gt;:o<\/font>~ig;    # >:o
					}

					# Sleep a bit and then send.
					$send =~ s/\'/\\'/ig;
					$chaos->{bots}->{$sn}->{temp}->{$lr} = $chat;
					&queue ($sn,3,"\$chaos->{bots}->{$sn}->{client}->chat_send (\$chaos->{bots}->{'$sn'}->{temp}->{'$lr'},"
						. "\'$send\',1);");
				}
			}
		}
		else {
			$reply = "noreply (muted)";
		}
	}
	else {
		print "$time\n"
			. "<From Chat: $room>\n"
			. "[$client] $msg\n\n";
	}
}
{
	Type        => 'handler',
	Name        => 'aim_chat_im_in',
	Description => 'Handles instant messages in chat.',
	Author      => 'Cerone Kirsle',
	Created     => '2:38 PM 11/20/2004',
	Updated     => '5:27 PM 12/9/2004',
	Version     => '1.0',
};