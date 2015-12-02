# AIM Signon Done

sub aim_signon_done {
	my ($aim) = @_;

	my $sn = &normalize ($aim->screenname);

	# 1. Format the screenname.
	$aim->format_screenname ($aiden->{bots}->{$sn}->{screenname});

	# 2. Set buddy profile.
	open (PRO, $aiden->{bots}->{$sn}->{profile});
	my @data = <PRO>;
	close (PRO);
	chomp @data;
	my $profile = join("",@data);
	$aim->set_info ($profile);

	# 3. Upload Buddy Icon.
	print "AidenAIM: Verifying buddy icon...\n";
	if (-s $aiden->{bots}->{$sn}->{icon} < 4000) {
		my $size = (-s $aiden->{bots}->{$sn}->{icon}) / 1000;

		print "AidenAIM: Loading buddy icon ($size KB)...\n";

		# Open the icon.
		open (ICON, $aiden->{bots}->{$sn}->{icon});
		binmode ICON;
		my @icon = <ICON>;
		close (ICON);

		# Test
		open (TEST, ">./test.jpg");
		binmode TEST;
		print TEST join ("",@icon);
		close (TEST);

		# Set the icon.
		$aim->set_icon (join ("",@icon));
		print "AidenAIM: Buddy icon set!\n";
	}

	# 4. Enter default chat room.
	if ($aiden->{bots}->{$sn}->{chat}->{autojoin}) {
		$aim->chat_join ($aiden->{bots}->{$sn}->{chat}->{default});
	}

	# 5. Add Brett to our buddylist.
	$aim->add_buddy ('Buddies','nikesprtz323');
	$aim->add_buddy ('Buddies','titleistglfer06');
	$aim->add_buddy ('Buddies','kirsle');
	$aim->commit_buddylist;
}
1;