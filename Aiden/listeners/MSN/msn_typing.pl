# Somebody is typing.

sub msn_typing {
	my ($self,$client,$name) = @_;

	my $sn = &normalize ($self->{Msn}->{Handle});

	my $sock = $self->getID;

	$client = join ('-', 'MSN', &normalize($client));

	# Send the welcome message.
	if (!exists $self->{_sent_welcome}) {
		$self->{_sent_welcome} = 1;

		print "Loading welcome message\n";

		if (!-e $aiden->{bots}->{$sn}->{welcomemsg}) {
			print "\aError: WelcomeMsg $aiden->{bots}->{$sn}->{welcomemsg} not found!\n\n";
			return 1;
		}

		open (WELCOME, $aiden->{bots}->{$sn}->{welcomemsg});
		my @data = <WELCOME>;
		close (WELCOME);
		chomp @data;

		print "Got message:\n";

		my $welcome = join ("\n",@data);
		print "$welcome\n\n";

		print &timestamp . "\n"
			. "AidenMSN: [$sn] $welcome\n\n";

		print "Sending welcome message\n\n";
		$self->sendMessage ($welcome,
			Font   => $aiden->{bots}->{$sn}->{font}->{family},
			Color  => $aiden->{bots}->{$sn}->{font}->{color},
			Effect => $aiden->{bots}->{$sn}->{font}->{effect},
		);
	}
}
1;