# A contact is adding us.

sub msn_add {
	my ($notify,$client) = @_;

	my $sn = &normalize ($notify->{Msn}->{Handle});
	$client = &normalize ($client);

	my @users = $aiden->{bots}->{$sn}->{client}->getContactList ('AL') or ();

	print &timestamp . "\n"
		. "AidenMSN: $client has added $sn to their contact list.\n";

	# See if they've already added another mirror...
	my $already = 0;
	foreach my $bot (keys %{$aiden->{bots}}) {
		next unless $aiden->{bots}->{$bot}->{listener} eq 'MSN';

		my @rl = $aiden->{bots}->{$bot}->{client}->getContactList ('RL') or ();
		my %list = ();
		foreach my $user (@rl) {
			$user = &normalize($user);
			$list{$user} = 1;
		}

		if (exists $list{$client}) {
			print "Debug // already added $bot to their list ($client; $list{$client})\n";
			$already++;
		}
	}

	# If they have...
	if ($already > 1 && !&isMaster(join('-','MSN',$client))) {
		print "AidenMSN: Addition denied--already added one mirror!\n\n";
		$aiden->{bots}->{$sn}->{client}->call ($client,
			'You already have one of my other MSN names on your contact list! You can only have one of '
			. 'mine on your list at a time. :-)',
			Font   => 'Verdana',
			Color  => '000000',
			Effect => '',
		);
		return 0;
	}

	# Limit is 400.
	if (scalar(@users) >= 400) {
		print "AidenMSN: Addition denied--contact list is full!\n\n";
		$aiden->{bots}->{$sn}->{client}->call ($client,
			'Sorry, but my contact list is full. Check back to where you got this address from to see '
			. 'if I have any mirrors you could add instead. :-)',
			Font   => 'Verdana',
			Color  => '000000',
			Effect => '',
		);
		return 0;
	}
	else {
		print "AidenMSN: Addition allowed!\n\n";
		return 1;
	}
}
1;