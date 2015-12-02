#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !aim
#    .::   ::.     Description // Execute AIM Commands (like shortcut URL's)
# ..:;;. ' .;;:..        Usage // !aim <command>[?arguments]
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub aim {
	my ($self,$client,$msg,$listener) = @_;

	# Filter things.
	$msg =~ s/\&amp\;/\&/ig;

	# Make sure we're on AIM.
	if ($listener eq "AIM") {
		# Split the command and the arguments.
		my ($command,$args) = split(/\?/, $msg, 2);

		my ($arg1,$arg2,$arg3);

		my $screenname = $self->screenname();

		# Make an array of the arguments.
		my @args = split(/\&/, $args);

		# Setup pairs of arguments.
		my %data;
		foreach $pair (@args) {
			($what,$is) = split(/=/, $pair, 2);
			$what = lc($what);
			$what =~ s/ //g;
			$data{$what} = $is;
		}

		# Okay, start executing commands.
		$command = lc($command);
		$command =~ s/ //g;

		if ($command eq "goim") {
			$arg1 = $data{"screenname"} if $data{"screenname"};
			$arg1 = $data{"sn"} if $data{"sn"};
			$arg2 = $data{"message"} if $data{"message"};
			$arg2 = $data{"msg"} if $data{"msg"};

			$arg1 = lc($arg1);
			$arg1 =~ s/ //g;

			# Make sure this user was active.
			if (!exists $chaos->{_users}->{$arg1}->{_active} || time - $chaos->{_users}->{$arg1}->{_active} > 60) {
				return "That username has not sent me a message in the last 60 "
					. "seconds. It's a security precaution that I never am "
					. "the one to initiate a new conversation. Get your friend "
					. "to send me a message, and then you can send them a "
					. "message through me. :-)";
			}

			&dosleep(3);
			$font = get_font($screenname,"AIM");
			my $out_msg = $font . $arg2;
			$self->send_im ($arg1,$out_msg);

			$reply = "I have sent the message.";
		}
		elsif ($command eq "gochat") {
			$arg1 = $data{"roomname"} if $data{"roomname"};
			$arg1 = $data{"room"} if $data{"$room"};

			&dosleep(3);
			$self->chat_join ($arg1);

			$reply = "Joining chatroom $arg1.";
		}
		else {
			$reply = "Invalid or unsupported AIM command.";
		}
	}
	else {
		$reply = "Sorry, this command is for AIM only.";
	}

	return $reply;
}

{
	Category => 'Bot Utilities',
	Description => 'Execute AIM Commands',
	Usage => '!aim <command>[?arguments]',
	Listener => 'AIM',
};