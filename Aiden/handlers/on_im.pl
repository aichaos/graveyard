# Global IM Handler.

sub on_im {
	my ($listener,$self,$client,$msg,$sn) = @_;

	print "Debug // on_im called\n"
		. "\t\@_ = $listener,$self,$client,$msg\n" if $aiden->{debug};

	# Skip msn objects.
	return '<noreply>' if $msg =~ /<msnobj/i;

	# Shutting up?
	if (exists $aiden->{data}->{shutup}) {
		if (!&isMaster($client)) {
			print &timestamp . "\n"
				. "Aiden$listener: [$client] $msg\n"
				. "On shut-up mode.\n\n";
			return '<noreply>';
		}
	}

	# Is this a new user?
	if (!exists $aiden->{clients}->{$client} || !-e "./clients/$client\.usr") {
		print "Debug // new user!\n" if $aiden->{debug};
		&userCreate ($client);
	}

	# Last client.
	$aiden->{data}->{lastclient} = $client;

	# Flood checking.
	my $flooding = $aiden->{system}->{flood}->check ($client,$msg);
	if ($flooding == -1) {
		print &timestamp . "\n"
			. "AidenSYS: Floodcheck Error!\n\n";
	}
	elsif ($flooding > 0) {
		print &timestamp . "\n"
			. "AidenSYS: Flooding detected from $client!\n\n";

		&blockUser ($client,1);

		return 'Flood detected. I\'m going to have to block you temporarily...';
	}

	# Create the reply.
	my $reply = '';

	# See if this user is block and/or is a warner.
	my ($blocked,$reason) = &isBlocked($client);
	my $isWarner = &isWarner($client);

	print "Debug // isBlocked: $blocked ($reason)\n"
		. "\tisWarner: $isWarner\n" if $aiden->{debug};

	# If either/or...
	if ($blocked == 1) {
		if (!exists $aiden->{clients}->{$client}->{sent_blockmsg}) {
			$aiden->{clients}->{$client}->{sent_blockmsg} = 1;
			$reply = "<auto>I'm sorry, but you're blocked and I cannot chat with you!\n\n"
				. "Block Description:\n"
				. "$reason";
		}
		else {
			$reply = '<noreply>';
		}
	}
	elsif ($isWarner == 1) {
		# Crash this user.
		$reply = "<Fontsml=f sml= ></Font>";
	}
	else {
		if (exists $aiden->{clients}->{$client}->{sent_blockmsg}) {
			delete $aiden->{clients}->{$client}->{sent_blockmsg};
		}
	}

	# Save an original unformatted message copy.
	my $omsg = $msg;

	# Continue.
	if ($blocked == 0 && $isWarner == 0) {
		# Save their message.
		$aiden->{clients}->{$client}->{omsg} = $omsg;

		# Convert MsgPlus into one sentence.
		$msg =~ s/Ping\? \[msgplus\]/ping msgplus/ig;

		# Set variables.
		foreach my $var (keys %{$aiden->{clients}->{$client}}) {
			my $val = $aiden->{clients}->{$client}->{$var};
			$aiden->{rive}->setUservar ($client,$var => $val);
		}

		# Set time variables...
		$aiden->{rive}->setVariable ('bothour', time_format('hh'));

		if (&isMaster($client)) {
			$aiden->{rive}->setUservar ($client, ismaster => 'true');
		}
		else {
			$aiden->{rive}->setUservar ($client, ismaster => 'false');
		}

		# See that they're not repeating themselves.
		print "Debug // Running repetition filter\n" if $aiden->{debug};
		for (my $i = 9; $i > 1; $i--) {
			print "\tOn Loop $i\n" if $aiden->{debug};
			my $j = $i + 1;
			$aiden->{clients}->{$client}->{history}->{$j} = $aiden->{clients}->{$client}->{history}->{$i};
		}
		$aiden->{clients}->{$client}->{history}->{1} = $msg;

		# Count their repeats.
		print "Debug // Counting repeats\n" if $aiden->{debug};
		my $repeats = 0;
		for (my $i = 2; $i <= 10; $i++) {
			print "\tLoop $i; repeats: $repeats\n" if $aiden->{debug};
			if (defined $aiden->{clients}->{$client}->{history}->{$i}) {
				$repeats++ if $aiden->{clients}->{$client}->{history}->{$i} eq $aiden->{clients}->{$client}->{history}->{1};
			}
		}

		# Process them.
		if ($repeats > 0 && $repeats < 7) {
			$msg = 'system repeat safe';
		}
		elsif ($repeats >= 7 && $repeats < 10) {
			$msg = 'system repeat warning';
		}
		elsif ($repeats >= 10) {
			$msg = 'system repeat ban';
			&blockUser ($client,1);
		}

		# New user?
		if ($aiden->{clients}->{$client}->{name} eq $client && !exists $aiden->{clients}->{$client}->{inreg}) {
			$aiden->{clients}->{$client}->{inreg} = 1;
			$msg = 'system reg new user';
		}

		# Fetch a reply.
		my @rep = $aiden->{rive}->reply ($client,$msg);
		my $rive = join (' ',@rep);
		$rive =~ s/no\-reply\-matched//g;
		$rive = "ERR: ON_IM No Reply" unless length $rive > 0;

		# Special variables we can use.
		my $day = time_format ('Weekday');
		my $year = time_format ('yyyy');
		my $month = time_format ('Month');
		my $mnum = time_format ('d');
		$rive =~ s/\$day/$day/ig;
		$rive =~ s/\$year/$year/ig;
		$rive =~ s/\$month/$month/ig;
		$rive =~ s/\$mnum/$mnum/ig;

		$rive =~ s/\\n/\n/g;

		$reply = $rive;
		unless (length $reply > 0) {
			$reply = $aiden->{rive}->reply ($client,'system no message');
			$reply = "ERR: Undef Reply" unless length $reply > 0;
		}

		print "Debug // final reply: $reply\n\n" if $aiden->{debug};

		# Save changed variables.
		my $vars = $aiden->{rive}->getUservars ($client);
		foreach my $var (keys %{$vars}) {
			if (exists $aiden->{clients}->{$client}->{$var}) {
				if ($aiden->{clients}->{$client}->{$var} ne $vars->{$var}) {
					print "Setting $var = $vars->{$var}\n";
					$aiden->{clinets}->{$client}->{$var} = $vars->{$var};
					&userSend ($client,$var,$vars->{$var});
				}
			}
			else {
				print "Setting $var = $vars->{$var}\n";
				$aiden->{clients}->{$client}->{$var} = $vars->{$var};
				&userSend ($client,$var,$vars->{$var});
			}
		}
	}

	# Log the convo.
	&log_im ($client,$omsg,$sn,$reply);

	# Return it.
	return $reply;
}
1;