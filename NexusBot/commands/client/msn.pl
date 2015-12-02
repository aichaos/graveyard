# COMMAND NAME:
#	MSN
# DESCRIPTION:
#	Execute MSN commands.
# COMPATIBILITY:
#	MSN

sub msn {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we're on MSN.
	if ($listener eq "MSN") {
		# Split the command and the arguments.
		my ($command,$args) = split(/\?/, $msg, 2);

		my $screenname = $self->GetMaster->{Handle};

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
			$arg1 = $data{"email"} if $data{"email"};
			$arg1 = $data{"handle"} if $data{"handle"};
			$arg1 = $data{"sn"} if $data{"sn"};
			$arg2 = $data{"message"} if $data{"message"};
			$arg2 = $data{"msg"} if $data{"msg"};

			($font_name,$font_color) = get_msn_font($screenname);
			$self->call ($arg1,"$arg2",Font => "$font_name",Color => "$font_color");

			$reply = "I have sent the message.";
		}
		elsif ($command eq "invite") {
			$arg1 = $data{"screenname"} if $data{"screenname"};
			$arg1 = $data{"email"} if $data{"email"};
			$arg1 = $data{"handle"} if $data{"handle"};
			$arg1 = $data{"sn"} if $data{"sn"};

			$reply = "Inviting $arg1 to the conversation...";

			$self->invite ($arg1);
		}
		elsif ($command eq "leave") {
			$self->sendtyping();
			sleep(1);
			$self->sendmsg ("Leaving the conversation...",Font => "Courier New",Color => "FF0000");
			$self->send ("OUT \r\n");
		}
		else {
			$reply = "Invalid or unsupported MSN command.";
		}
	}
	else {
		$reply = "Sorry, this command is for MSN only.";
	}

	return $reply;
}
1;