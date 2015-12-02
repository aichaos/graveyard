# You're Connected.

sub msn_connected {
	my ($msn) = @_;

	my $sn = &normalize ($msn->{Handle});

	# Set nickname.
	$msn->setName ($aiden->{bots}->{$sn}->{nick});

	# Set display picture.
	$msn->setDisplayPicture ($aiden->{bots}->{$sn}->{displaypic});

	# Set default font.
	$msn->setMessageStyle (
		Font   => $aiden->{bots}->{$sn}->{font}->{family},
		Color  => $aiden->{bots}->{$sn}->{font}->{color},
		Effect => $aiden->{bots}->{$sn}->{font}->{effect},
	);

	# Setup Emoticons.
	open (EMO, $aiden->{bots}->{$sn}->{emoticons});
	my @emo = <EMO>;
	close (EMO);
	chomp @emo;

	foreach my $line (@emo) {
		my ($code,$file) = split(/===/, $line, 2);
		next unless -e $file;

		$msn->addEmoticon ($code,$file);
	}
}
1;