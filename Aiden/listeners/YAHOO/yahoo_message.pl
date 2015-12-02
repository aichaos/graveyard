# Yahoo messages.

sub yahoo_message {
	my ($yahoo,$from,$msg) = @_;

	my $sn = &normalize($yahoo->{username});

	# Format the client's name.
	$from = lc($from); $from =~ s/ //g;
	my $client = join ('-', 'YAHOO', $from);

	# Remove HTML from the message.
	$msg =~ s/<(.|\n)+?>//g;
	$msg =~ s/^[^A-Za-z0-9 ]//g;

	# Send this data to the IM In handler.
	my $reply = &on_im ('YAHOO',$yahoo,$client,$msg,$sn);

	# Send the reply.
	if ($reply !~ /<noreply>/i) {
		my $font = $aiden->{bots}->{$sn}->{font}->{family};
		my $color = $aiden->{bots}->{$sn}->{font}->{color};
		my $style = $aiden->{bots}->{$sn}->{font}->{style};

		# Enqueue this message.
		$reply =~ s/\'/\\'/g;
		&queue ($sn,3,"\$aiden->{bots}->{'$sn'}->{client}->sendMessage ('$from','$reply', "
			. "font => '$font', color => '$color', style => '$style');");
	}
}
1;