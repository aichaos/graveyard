# Botmaster Commands

$aiden->{rive}->setSubroutine (botmaster => \&cmd_botmaster);

sub cmd_botmaster {
	my ($method,$data) = @_;

	if ($method eq 'reload') {
		&reload();
		return 'Reload Successful!';
	}
	elsif ($method eq 'replycount') {
		return $aiden->{rive}->{sort}->{replycount};
	}
	elsif ($method eq 'msn') {
		# Find the MSN usage statistics.
		my $return = '';
		foreach my $bot (keys %{$aiden->{bots}}) {
			next unless $aiden->{bots}->{$bot}->{listener} eq 'MSN';

			my @rl = $aiden->{bots}->{$bot}->{client}->getContactList('RL');
			my $count = scalar(@rl);
			my $max = 400;
			my $percent = ($count / $max);
			$percent =~ s/\.(.).*?/\.$1/g;
			$percent .= '%';

			if ($data eq 'users') {
				$return .= "$bot users:\n" . join ("\n",@rl) . "\n\n";
			}
			else {
				$return .= "$bot: $count / $max ($percent)\n";
			}
		}
		return $return;
	}
	elsif ($method eq 'search') {
		my @results = $aiden->{rive}->search ($data);

		my @return = ();
		foreach my $item (@results) {
			$item =~ s/</&lt;/g;
			$item =~ s/>/&gt;/g;
		}

		return "Results:\n\n"
			. join ("\n",@results);
	}
	elsif ($method eq 'idle') {
		if ($data eq 'on') {
			$aiden->{bots}->{aidencks}->{client}->set_away ('Hang on...');
			$aiden->{bots}->{'aiden@aichaos.com'}->{client}->setStatus ('AWY');
			$aiden->{bots}->{'aiden@rivescript.com'}->{client}->setStatus ('AWY');
			$aiden->{data}->{shutup} = 1;
			return 'activated.';
		}
		else {
			$aiden->{bots}->{aidencks}->{client}->set_away ('');
			$aiden->{bots}->{'aiden@aichaos.com'}->{client}->setStatus ('NLN');
			$aiden->{bots}->{'aiden@rivescript.com'}->{client}->setStatus ('NLN');
			$aiden->{data}->{shutup} = 0;
			return 'deactivated.';
		}
	}
	elsif ($method eq 'debug') {
		if ($data eq 'on') {
			$aiden->{debug} = 1;
		}
		else {
			$aiden->{debug} = 0;
		}
		return $data;
	}
	elsif ($method eq 'clearlogs') {
		unlink ("./logs/chat/convo.html");
		return 'deleted!';
	}
	elsif ($method eq 'block') {
		# Block a user.
		my ($listener,$user) = split(/\,/, $data, 2);
		$listener = uc($listener);
		$listener =~ s/ //g;
		$user = lc($user);
		$user =~ s/ //g;

		my $client = join ('-',$listener,$user);

		# Block them.
		my $mins = &blockUser ($client);

		return "Blocked $client for $mins minutes.";
	}
	elsif ($method eq 'ban') {
		# Ban a user.
		my ($listener,$user,$reason) = split(/\,/, $data, 3);
		$listener = uc($listener);
		$listener =~ s/ //g;
		$user = lc($user);
		$user =~ s/ //g;

		my $client = join ('-',$listener,$user);

		# Blacklist him.
		open (LIST, "./data/blacklist.txt");
		my @data = <LIST>;
		close (LIST);
		chomp @data;

		push (@data, join ('::',$client,$reason));

		open (NEW, ">./data/blacklist.txt");
		print NEW join ("\n",@data);
		close (NEW);

		return "Banned $client for: $reason";
	}
	else {
		return 'unknown method';
	}
}

1;
