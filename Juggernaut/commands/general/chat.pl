#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !chat
#    .::   ::.     Description // Juggernaut Chat
# ..:;;. ' .;;:..        Usage // !chat
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub chat {
	my ($self,$client,$msg,$listener) = @_;

	# Information about this exact copy of the command.
	my $VER = '1.0';

	# Only supports the active listeners (no HTTP).
	return "The chat room only applies to the active listeners (AIM, MSN, "
		. "and IRC)." unless $listener =~ /^(aim|msn|irc)$/i;

	# Get the bot's username.
	my $sn;
	$sn = $self->{Msn}->{Handle} if $listener eq "MSN";
	$sn = $self->screenname()    if $listener eq "AIM";
	$sn = $self->nick()          if $listener eq "IRC";
	$sn = lc($sn);
	$sn =~ s/ //g;

	# The listener will be lowercased.
	$listener = lc($listener);

	# Must be in the chat callback.
	if (exists $chaos->{_users}->{$client}->{callback}) {
		# Is this a chat command?
		if (lc($msg) eq "help") {
			return ":: Chat Help ::\n\n"
				. "Type \"help <lt>category<gt>\" for a category listed "
				. "below:\n\n"
				. "<gt> about\n"
				. "<gt> commands\n"
				. "<gt> credits\n\n"
				. "J'naut Chat version $VER";
		}
		elsif (lc($msg) eq "help about") {
			return ":: About Chat ::\n\n"
				. "Juggernaut Chat is a cross-messenger simulated chat room. "
				. "Each member of the chat is in their own one-on-one conversation "
				. "with the bot, and any messages sent to the bot will be "
				. "broadcasted to all users (unless the message triggered a command). "
				. "With this chat, users from AOL Instant Messenger, MSN Messenger, "
				. "and Internet Relay Chat channels can communicate with eachother.";
		}
		elsif (lc($msg) eq "help commands") {
			return ":: Chat Commands ::\n\n"
				. "Type a command to use it. The commands are as follows:\n\n"
				. "(*) Public Commands (*)\n"
				. "help [category] -- Chat Help\n"
				. "who -- Lists the Members\n"
				. "whois [user] -- Info about a user\n"
				. "whoami -- Who are you?\n"
				. "topic -- Current topic\n"
				. "exit -- Leave the Chat\n\n"
				. "(*) Admin Commands (*)\n"
				. "Note: Bot Moderators and up can use these:\n"
				. "kick <lt>user<gt> -- Kick a user from chat\n"
				. "ban <lt>user<gt> -- Ban a user from chat\n"
				. "unban <lt>user<gt> -- Unban a user\n"
				. "topic <lt>new topic<gt> -- Sets the topic\n"
				. "kill -- Terminates the chat for all users";
		}
		elsif (lc($msg) eq "help credits") {
			return ":: Credits ::\n\n"
				. "Chat Version: $VER\n"
				. "Programmer: Cerone Kirsle\n\n"
				. "Copyright 2004 Chaos AI Technology\n"
				. "juggernaut\@aichaos.com";
		}
		elsif (lc($msg) eq "who") {
			# Get the users.
			my @users = keys %{$chaos->{_data}->{chatsys}->{members}};
			return ":: Chat Participants ::\n\n"
				. join ("\n", @users);
		}
		elsif (lc($msg) eq "whoami") {
			return ":: User Information ::\n\n"
				. "You are $client\n"
				. "Listener: $chaos->{_data}->{chatsys}->{members}->{$client}->{listener}\n"
				. "Host: $chaos->{_data}->{chatsys}->{members}->{$client}->{host}";
		}
		elsif ($msg =~ /^whois (.*?)$/i) {
			# Whois a user.
			my $whois = $1;

			return "That user is not in chat." unless exists $chaos->{_data}->{chatsys}->{members}->{$whois};

			# Return information.
			return ":: User Information ::\n\n"
				. "Username: $whois\n"
				. "Listener: $chaos->{_data}->{chatsys}->{members}->{$whois}->{listener}\n"
				. "Chat Host: $chaos->{_data}->{chatsys}->{members}->{$whois}->{host}";
		}
		elsif (lc($msg) eq "topic") {
			return "The current topic is: $chaos->{_data}->{chatsys}->{topic}";
		}
		elsif (lc($msg) eq "exit") {
			# Exit!
			&chat_send ('exit', $client);

			# Delete them.
			delete $chaos->{_users}->{$client}->{callback};
			delete $chaos->{_data}->{chatsys}->{members}->{$client};

			return "<noreply--chatroom>";
		}
		elsif (isMod ($client,$listener) && $msg =~ /^kick (.*?)$/i) {
			my $kick = $1;
			$kick = lc($kick);
			$kick =~ s/ //g;

			return "That user is not in chat." unless
				exists $chaos->{_data}->{chatsys}->{members}->{$kick};

			# Broadcast this.
			&chat_send ('kick', $kick);

			# Delete them.
			delete $chaos->{_users}->{$kick}->{callback};
			delete $chaos->{_data}->{chatsys}->{members}->{$kick};

			return "<noreply--chatroom>";
		}
		elsif (isMod ($client,$listener) && $msg =~ /^ban (.*?)$/i) {
			my $ban = $1;
			$ban = lc($ban);
			$ban =~ s/ //g;

			return "That user is not in chat." unless
				exists $chaos->{_data}->{chatsys}->{members}->{$ban};

			my $ban_lis = $chaos->{_data}->{chatsys}->{members}->{$ban}->{listener};

			# Add the user to the banned list.
			if (-e "./data/chatban.txt") {
				open (BAN, ">>./data/chatban.txt");
				print BAN "\n$ban";
				close (BAN);
			}
			else {
				open (NEW, ">./data/chatban.txt");
				print NEW "$ban";
				close (NEW);
			}

			# Broadcast this.
			&chat_send ('ban', $ban);

			# Delete them.
			delete $chaos->{_users}->{$ban}->{callback};
			delete $chaos->{_data}->{chatsys}->{members}->{$ban};
		}
		elsif (isMod ($client,$listener) && $msg =~ /^unban (.*?)$/i) {
			my $unban = $1;
			$unban =~ s/ //g;
			$unban = lc($unban);

			return "There is no ban list on record." unless (-e "./data/chatban.txt");

			# Open the ban list.
			open (BEFORE, "./data/chatban.txt");
			my @ban = <BEFORE>;
			close (BEFORE);
			chomp @ban;

			my $unban_found = 0;
			my @newlist;
			foreach my $line (@ban) {
				if ($line eq $unban) {
					$unban_found = 1;
				}
				else {
					push (@newlist,$line);
				}
			}

			# If found...
			return "That username does not appear to be banned!" unless $unban_found;

			# Save the new list.
			open (AFTER, ">./data/chatban.txt");
			print AFTER join ("\n", @newlist);
			close (AFTER);

			return "$unban has been unbanned.";
		}
		elsif (isMod ($client,$listener) && $msg =~ /^topic (.*?)$/i) {
			my $topic = $1;

			# Broadcast this.
			&chat_send ('topic', $topic);

			# Fix the topic.
			$chaos->{_data}->{chatsys}->{topic} = $topic;

			return "<noreply--chatroom>";
		}
		elsif (isMod ($client,$listener) && $msg eq "kill") {
			# Kill the chat.

			# Broadcast this.
			&chat_send ('kill', $client);

			# Delete all users.
			foreach my $user (keys %{$chaos->{_data}->{chatsys}->{members}}) {
				delete $chaos->{_users}->{$user}->{callback};
			}
			delete $chaos->{_data}->{chatsys};

			return "<noreply--chatroom>";
		}
		else {
			# A normal message.
			&chat_send ('msg', $client, $msg);

			return "<noreply--chatroom>";
		}
	}
	else {
		# Make sure they're not banned.
		if (&chat_banned ($client)) {
			return "You are banned from chatting here.";
		}

		# Join the chat!
		$chaos->{_users}->{$client}->{callback} = "chat";
		if (!exists $chaos->{_data}->{chatsys}->{topic}) {
			$chaos->{_data}->{chatsys}->{topic} = "General";
		}
		$chaos->{_data}->{chatsys}->{members}->{$client}->{listener} = $listener;
		$chaos->{_data}->{chatsys}->{members}->{$client}->{host} = $sn;
		$chaos->{_data}->{chatsys}->{members}->{$client}->{sock} = $self->getID if $listener eq "msn";

		# Broadcast this.
		&chat_send ('join', $client);

		return "Welcome to chat! Type \"help\" if you have any questions.";
	}
}
sub chat_banned {
	# Check this user.
	my $user = shift;

	# Ban list.
	return 0 unless (-e "./data/chatban.txt");

	# Open it.
	open (DATA, "./data/chatban.txt");
	my @data = <DATA>;
	close (DATA);
	chomp @data;

	foreach my $line (@data) {
		return 1 if $line eq $user;
	}

	return 0;
}
sub chat_send {
	my ($type,@args) = @_;

	# Prepare some variables.
	my $reply;

	# Go through the types.
	if ($type eq 'join') {
		$reply = "Please welcome $args[0], chatting here from "
			. uc($chaos->{_data}->{chatsys}->{members}->{$args[0]}->{listener})
			. "!";
	}
	elsif ($type eq 'msg') {
		$reply = "[$args[0]] $args[1]";
	}
	elsif ($type eq 'topic') {
		$reply = "*** The topic has been changed to: $args[0] ***";
	}
	elsif ($type eq 'kick') {
		$reply = "*** $args[0] has been kicked from the room. ***";
	}
	elsif ($type eq 'ban') {
		$reply = "*** $args[0] has been banned. ***";
	}
	elsif ($type eq 'kill') {
		$reply = "The chat room has been terminated by administrator $args[0].";
	}
	elsif ($type eq 'exit') {
		$reply = "$args[0] has left the chat room.";
	}
	elsif ($type eq 'idle') {
		$reply = "$args[0] has been disconnected from chat (idle).";
	}
	else {
		$reply = "Unknown message type: Arguments = @args";
	}

	# The reply header.
	$reply = ":: J'naut Chat ::\n\n"
		. $reply;

	# Broadcast the message!
	my ($out,$host,$listener,$sock,$convo);
	foreach my $client (keys %{$chaos->{_data}->{chatsys}->{members}}) {
		$host = $chaos->{_data}->{chatsys}->{members}->{$client}->{host};
		$listener = $chaos->{_data}->{chatsys}->{members}->{$client}->{listener};

		next if length $listener == 0;
		next if length $host == 0;

		# Update the callback in case they drifted.
		$chaos->{_users}->{$client}->{callback} = "chat";

		# Get this message sent!
		if ($listener eq "aim") {
			# Use this host.
			$out = $reply;
			$out =~ s/\n/<br>/ig;
			$out = "<body bgcolor=\"#FFFFFF\" link=\"#0000FF\" vlink=\"#0000FF\">"
				. "<font face=\"Verdana,Arial\" size=\"2\" color=\"#000000\">"
				. "<b>$out</b>"
				. "</font></body>";

			&dosleep (3);
			$chaos->{$host}->{client}->send_im ($client,$out);
		}
		elsif ($listener eq "msn") {
			# Use this host.
			$sock = $chaos->{_data}->{chatsys}->{members}->{$client}->{sock};
			next if length $sock == 0;

			$convo = $chaos->{$host}->{client}->getConvo ($sock);

			# Make sure this conversation is empty.
			my $buddies = $convo->getMembers ();
			my @msn_buds = keys %{$buddies};
			if (scalar @msn_buds > 1) {
				# Delete them.
				delete $chaos->{_users}->{$client}->{callback};
				delete $chaos->{_data}->{chatsys}->{members}->{$client};
				next;
			}

			# Send a message!
			$convo->sendmsg ($reply,
				Font => "Verdana",
				Color => "000000",
				Style => "B",
			);
		}
		elsif ($listener eq "irc") {
			# Format the username.
			$client =~ s/^irc\_//ig;

			my @mess = split(/\n/, $reply);

			foreach my $send (@mess) {
				$self->privmsg ($client,$send);
			}
		}
		else {
			next;
		}
	}

	# Return.
	return 1;
}

{
	Category => 'General',
	Description => 'Universal Chatroom',
	Usage => '!chat',
	Listener => 'All',
};