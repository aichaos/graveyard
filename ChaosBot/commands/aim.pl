# COMMAND NAME:
#	AIM
# DESCRIPTION:
#	Performs AIM functions. Similar to AIM shortcut URL's.
# COMPATIBILITY:
#	AIM

sub aim {
	# Get variables from the shift.
	my ($client,$msg,$aim) = @_;

	# Cut the command off.
	$msg =~ s/\!aim //ig;

	# Get the REAL & symbol.
	$msg =~ s/\&amp\;/\&/ig;

	# Get the command and the arguments.
	my ($command,$details) = split(/\?/, $msg);

	# Sort through the arguments.
	my %args;
	my @pairs = split(/\&/, $details);
	foreach $item (@pairs) {
		my ($what,@is) = split(/=/, $item);
		my $is = join(/=/, @is);

		$what = lc($what);

		$args{$what} = $is;
	}

	# Go through each command.
	my $to;
	my $say;
	if ($command eq "goim") {
		$to = $args{"screenname"} if $args{"screenname"};
		$to = $args{"sn"} if $args{"sn"};
		$say = $args{"message"} if $args{"message"};
		$say = $args{"msg"} if $args{"msg"};

		if (warners($aim,$to)) {
			$reply = "I will not send the message because $to is on my warners list.";
		}
		else {
			# Send the IM.
			sleep(dosleep(1,3));
			$aim->send_im ($to,"<body bgcolor=white><font face=Verdana size=2 color=black>"
				. "$say</font></body>");

			$reply = "I have sent the message.";
		}
	}
	elsif ($command eq "goaway") {
		# Going away is Mod-only.
		if (isAdmin($client) || isMod($client)) {
			$say = $args{"message"} if $args{"message"};
			$say = $args{"msg"} if $args{"msg"};

			# Go away.
			$aim->set_away ($say);

			if ($say ne "") {
				$is_away = 1;
			}
			else {
				$is_away = 0;
			}

			$reply = "I have put up the away message.";
		}
		else {
			$reply = "This is a moderator-only command.";
		}
	}
	elsif ($command eq "return") {
		# Returning from away is Mod-only.
		if (isAdmin($client) || isMod($client)) {
			# Come back.
			$aim->set_away ("");

			$is_away = 0;

			$reply = "I have returned.";
		}
		else {
			$reply = "This is a moderator-only command.";
		}
	}
	elsif ($command eq "gochat") {
		$to = $args{"roomname"} if $args{"roomname"};
		$to = $args{"room"} if $args{"room"};

		# Join the chat room.
		$aim->chat_join ($to);

		$reply = "I have joined room $to.";
	}
	elsif ($command eq "invite") {
		$to = $args{"to"} if $args{"to"};
		$to = $args{"screennames"} if $args{"screennames"};
		$to = $args{"screenname"} if $args{"screenname"};
		$say = $args{"message"} if $args{"message"};
		$say = $args{"msg"} if $args{"msg"};

		if (warners($aim,$to)) {
			$reply = "I will not invite $to because he's a warner.";
		}
		else {
			# Invite.
			$aim->chat_invite ($to,$msg);

			$reply = "Sending chat invitation.";
		}
	}
	elsif ($command eq "exit") {
		$to = $args{"roomname"} if $args{"roomname"};
		$to = $args{"room"} if $args{"room"};

		# Leave the chat room.
		#$aim->chat_leave ($to);

		$reply = "(under construction) I have left chat room $to.";
	}
	elsif ($command eq "idle") {
		if (isMod($client) || isAdmin($client)) {
			$to = $args{"time"} if $args{"time"};

			# Go idle.
			$aim->set_idle ($time);

			$reply = "I have set my idle time for $time.";
		}
		else {
			$reply = "This is a Moderator-only command.";
		}
	}
	elsif ($command eq "warn") {
		# Warnings are moderator only.
		if (isMod($client) || isAdmin($client)) {
			$to = $args{"screenname"} if $args{"screenname"};
			$to = $args{"sn"} if $args{"sn"};

			# Warn the bastard.
			$aim->evil ($to, 0);

			$reply = "I have warned $to.";
		}
		else {
			$reply = "Sorry, this is a Moderator-only command!";
		}
	}
	elsif ($command eq "block") {
		# Block/unblock is moderator only.
		if (isMod($client) || isAdmin($client)) {
			$to = $args{"screenname"} if $args{"screenname"};
			$to = $args{"sn"} if $args{"sn"};

			# Block them.
			$aim->add_deny ($to);

			$reply = "I have blocked $to.";
		}
		else {
			$reply = "Sorry, this is a Moderator-only command!";
		}
	}
	elsif ($command eq "unblock") {
		# Block/unblock is moderator only.
		if (isMod($client) || isAdmin($client)) {
			$to = $args{"screenname"} if $args{"screenname"};
			$to = $args{"sn"} if $args{"sn"};

			# Unblock them.
			$aim->remove_deny ($to);

			$reply = "I have unblocked $to.";
		}
		else {
			$reply = "Sorry, this is a Moderator-only command!";
		}
	}
	elsif ($command eq "signoff") {
		# Signing off is moderator only.
		if (isMod($client) || isAdmin($client)) {
			$aim->send_im ($client, "Signing off...");
			sleep(2);
			$aim->signoff();
		}
		else {
			$reply = "Sorry, this is a Moderator-only command!";
		}
	}
	else {
		$reply = ("Invalid usage of the command. Commands are "
			. "used like AIM shortcut URL's. Example: "
			. "!aim goim?ScreenName=..&Message=..");
	}

	return $reply;
}
1;