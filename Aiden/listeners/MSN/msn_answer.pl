# We answered the ring.

sub msn_answer {
	my ($self) = @_;

	my $sn = &normalize ($notify->{Msn}->{Handle});

	my $buddies = $self->getMembers();
	my $client = join (',', keys %{$buddies});
	my @in = split(/\,/, $client);

	my $sock = $self->getID;

	print &timestamp . "\n"
		. "AidenMSN: Opening socket #$sock\n"
		. "Members: $client\n\n";

	# One-on-one conversations ONLY.
	if (scalar(@in) > 1) {
		# If there's more than 3: block all of them temporarily.
		if (scalar(@in) >= 3) {
			print "AidenMSN: Blocking all users in socket #$sock -- too many of them!\n\n";
			foreach my $user (@in) {
				my $int = join ('-', 'MSN', &normalize($user));
				&blockUser ($int,1);
			}
		}

		print "AidenMSN: Leaving socket #$sock -- too many members!\n\n";

		eval ('$self->leave();');
	}
}
1;