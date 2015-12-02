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
# MSN Handler: answer
# Description: Called when the bot's request has been answered.

sub msn_answer {
	# Get variables from the server.
	my $self = shift;

	# Get this user's name.
	my $sock = $self->getID;
	my $buddies = $self->getMembers ($sock);
	my $client = join (",", keys %{$buddies});
	$client = '<unknown>' unless defined $client;

	&panic ("Unknown username from the MSN Answer handler.", 0) if $client eq '<unknown>';

	$client = lc($client);
	$client =~ s/ //g;

	# Get the local time and our handle.
	my $time = localtime();
	my $screenname = $self->{Msn}->{Handle};
	my $sn = lc($screenname);
	$sn =~ s/ //g;

	my @users = split(/\,/, $client);

	# If this socket was previously used as a SHUT UP! socket...
	if (exists $chaos->{$sn}->{_shutup}->{$sock}) {
		delete $chaos->{$sn}->{_shutup}->{$sock};
	}

	# Log this event.
	print "ChaosMSN // $client created new socket (\#$sock)!\n\n";
	open (LOG, ">>./logs/$sn\.txt");
	print LOG localtime(time) . "\n"
		. "ChaosMSN // $client created new socket (\#$sock)!\n\n";
	close (LOG);

	# Get the font.
	my ($font,$color,$style) = get_font ($screenname, "MSN");

	my $stamp = $chaos->{_system}->{config}->{timestamp} || '<day_abbrev> <month_abbrev> <day_month> <hour_24>:<min>:<secs> <year_full>';
	$stamp = &get_date ('local',$stamp);

	# Leave the conversation?
	if (scalar(@users) > 3) {
		open (LOG2, ">>./logs/$sn\.txt");
		print LOG2 "Left Socket \#$sock (Too Many People: " . scalar(@users) . " in total)\n\n";
		close (LOG2);
		$self->sendmsg ("Eeek! Chat! Please refrain from inviting me into conversations with more "
			. "than three people at a time. Too many invite me to other bot-infested rooms "
			. "and it's not good for me. Thanks!",
			Font => "$font",
			Color => "$color",
			Style => "$style",
		);
		print "<$stamp>\n"
			. "[$sn] Eeek! Chat! Please refrain from inviting me into conversations with more "
			. "than three people at a time. Too many invite me to other bot-infested rooms "
			. "and it's not good for me. Thanks!\n\n";
		sleep(1);
		$self->leave ();
		return 1;
	}

	# See if they're blocked...
	my ($isBlocked,$blockee,$blockeeLevel) = (0,'','');
	foreach my $usr (@users) {
		my ($blocked,$blockLevel) = isBlocked($usr,"MSN");

		if ($blocked == 1) {
			$isBlocked = 1;
			$blockee = $usr;
			$blockeeLevel = $blockLevel;
			last;
		}
	}
	if ($isBlocked == 1) {
		# Get the description.
		my $block_reason;
		$blockLevel = $blockeeLevel;
		if ($blockLevel == 1) {
			# Get the expiration time.
			my $block_key = "msn-" . $blockee;
			my $block_expire = $chaos->{_data}->{blocks}->{$block_key};
			my $block_left = $block_expire - time();
			my $block_hours = int($block_left / (60*60));
			$block_reason = "Temporary block: Approximately $block_hours hours left.";
		}
		elsif ($blockLevel == 2) {
			$block_reason = "Permanent ban (BlackList).";
		}
		elsif ($blockLevel == 3) {
			$block_reason = "Loophole Connection.";
		}
		else {
			$block_reason = "Unknown";
		}

		my $blockreply;

		# If there are multiple people...
		if (scalar @users > 1) {
			$blockreply = "One of you are blocked from chatting with me, and I will not remain "
				. "in this conversation. The block description is as follows:\n\n"
				. "User $blockee\n"
				. "$block_reason";
			$self->sendmsg ($blockreply,
				Font => "Verdana",
				Color => "000000",
				Style => "B",
			);

			$self->leave ();
			return 1;
		}
		else {
			$blockreply = "Hello, $blockee. I'm informing you that you are currently blocked from "
				. "chatting with me. The description is as follows:\n\n"
				. "$block_reason";
			$self->sendmsg ($blockreply,
				Font => "Verdana",
				Color => "000000",
				Style => "B",
			);
		}
		print "<$stamp>\n"
			. "[$sn] $blockreply\n\n";

		return 1;
	}

	# Maintenance mode?
	if ($chaos->{_system}->{maintain}->{on} == 1) {
		$self->sendmsg ("Sorry, but maintenance mode is currently activated and I "
			. "may not be allowed to chat right now!",
			Font => "Verdana",
			Color => "FF0000",
			Style => "B",
		);
		print "<$stamp>\n"
			. "[$sn] Sorry, but maintenance mode is currently activated and I "
			. "may not be allowed to chat right now!\n\n";
		return 1;
	}

	# Load the welcome message.
	if (exists $chaos->{$screenname}->{welcomemsg}) {
		open (MSG, $chaos->{$screenname}->{welcomemsg});
		my @msg = <MSG>;
		close (MSG);

		chomp @msg;

		my $welcome;
		foreach my $line (@msg) {
			$welcome .= "$line\n";
		}

		# Send the message.
		$self->sendmsg ($welcome,
			Font  => "$font",
			Color => "$color",
			Style => "$style",
		);
		print "<$stamp>\n"
			. "[$sn] $welcome\n\n";
	}
}
1;