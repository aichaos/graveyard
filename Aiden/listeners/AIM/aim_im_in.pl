# Incoming IM's.

sub aim_im_in {
	my ($aim,$from,$msg,$away) = @_;

	# Skip away messages.
	return 0 if $away == 1;

	my $sn = &normalize($aim->screenname);

	# Format the client's name.
	$from = lc($from); $from =~ s/ //g;
	my $client = join ('-', 'AIM', $from);

	# Remove HTML from the message.
	$msg =~ s/<(.|\n)+?>//g;

	# Send this data to the IM In handler.
	my $reply = &on_im ('AIM',$aim,$client,$msg,$sn);

	# Send the reply.
	if ($reply !~ /<noreply>/i) {
		my $bg = $aiden->{bots}->{$sn}->{font}->{background};
		my $font = $aiden->{bots}->{$sn}->{font}->{family};
		my $link = $aiden->{bots}->{$sn}->{font}->{link};
		my $color = $aiden->{bots}->{$sn}->{font}->{color};
		my $size = $aiden->{bots}->{$sn}->{font}->{size};

		$reply =~ s/\n/<br>/g;

		my $send = "<html><body bgcolor=\"$bg\" link=\"$link\"><font face=\"$font\" color=\"$color\" back=\"$bg\" size=\"$size\">"
			. "$reply</font></body></html>";

		my $auto = 0;
		$auto = 1 if $reply =~ /<auto>/i;
		$reply =~ s/<auto>//ig;

		# Enqueue this message.
		$send =~ s/\'/\\'/g;
		$aim->send_typing_status ($from,TYPINGSTATUS_STARTED);
		&queue ($sn,3,"\$aiden->{bots}->{'$sn'}->{client}->send_im ('$from','$send',$auto);");
	}
}
1;