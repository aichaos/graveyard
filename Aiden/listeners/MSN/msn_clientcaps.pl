# Receiving ClientCaps.

sub msn_clientcaps {
	my ($msn,$user,%caps) = @_;

	my $sn = &normalize ($msn->{Handle});

	print &timestamp . "\n"
		. "AidenMSN: Received ClientCaps from $user\n";

	foreach my $key (keys %caps) {
		print "\t$key: $caps{$key}\n";
	}

	# If a bot...
	my $isBot = 0;
	if (exists $caps{'Client-Type'}) {
		if ($caps{'Client-Type'} =~ /bot/i) {
			$isBot = 1;
		}
	}
	if ($caps{'Client-Name'} =~ /bot/i) {
		$isBot = 1;
	}

	# If a bot...
	if ($isBot == 1) {
		# Block him.
		my $client = join ('-', 'MSN', &normalize($user));
		print "AidenMSN: Blocking $client -- it's a bot!\n\n";
		&blockUser ($client);
	}
	else {
		print "\n";
	}
}
1;