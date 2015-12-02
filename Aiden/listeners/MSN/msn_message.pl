# Somebody sent us a message.

sub msn_message {
	my ($self,$client,$name,$msg) = @_;

	my $sn = &normalize ($self->{Msn}->{Handle});
	my $sock = $self->getID;
	$client = join ('-', 'MSN', &normalize($client));

	# Get a reply.
	my $reply = &on_im ('MSN',$self,$client,$msg,$sn);

	# Send it.
	if ($reply !~ /<noreply>/i) {
		my $send = $reply;
		$send =~ s/<(.|\n)+?>//g;
		$send =~ s/\'/\\'/g;

		# Enqueue everything.
		$self->sendTyping();
		$aiden->{bots}->{$sn}->{_msnsox}->{$sock} = $self;
		&queue ($sn,0,"\$aiden->{bots}->{'$sn'}->{_msnsox}->{$sock}->sendMessage ('$send',
			Font   => \$aiden->{bots}->{'$sn'}->{font}->{family},
			Color  => \$aiden->{bots}->{'$sn'}->{font}->{color},
			Effect => \$aiden->{bots}->{'$sn'}->{font}->{effect},
		);");
	}
}
1;