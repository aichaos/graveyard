#              ::.                   .:.
#               .;;:  ..:::::::.  .,;:
#                 ii;,,::.....::,;;i:
#               .,;ii:          :ii;;:
#             .;, ,iii.         iii: .;,
#            ,;   ;iii.         iii;   :;.
# .         ,,   ,iii,          ;iii;   ,;
#  ::       i  :;iii;     ;.    .;iii;.  ,,      .:;
#   .,;,,,,;iiiiii;:     ,ii:     :;iiii;;i:::,,;:
#     .:,;iii;;;,.      ;iiii:      :,;iiiiii;,:
#          :;        .:,,:..:,,.        .:;..
#           i.                  .        ,:
#           :;.         ..:...          ,;
#            ,;.    .,;iiiiiiii;:.     ,,
#             .;,  :iiiii;;;;iiiii,  :;:
#                ,iii,:        .,ii;;.
#                ,ii,,,,:::::::,,,;i;
#                ;;.   ...:.:..    ;i
#                ;:                :;
#                .:                ..
#                 ,                :
# AIM Handler: signon_done
# Description: Called when signon is complete.

sub aim_signon_done {
	my ($aim) = @_;

	# Get some data.
	my $screenname = $aim->screenname();
	my $time = &get_timestamp();

	# Format the screenname.
	my $sn = lc($screenname);
	$sn =~ s/ //g;
	if (length $chaos->{bots}->{$sn}->{format} > 0) {
		$aim->format_screenname ($chaos->{bots}->{$sn}->{format});
	}

	# Set buddy icon.
	if (length $chaos->{bots}->{$sn}->{icon} > 0) {
		print "ChaosAIM: Verifying buddy icon...\n";

		# Icon must be under 4 KB.
		if (-s $chaos->{bots}->{$sn}->{icon} < 4000) {
			my $size = (-s $chaos->{bots}->{$sn}->{icon}) / 1000;

			print "ChaosAIM: Loading buddy icon ($size KB)...\n";

			# Open the icon.
			open (ICON, $chaos->{bots}->{$sn}->{icon});
			binmode ICON;
			my @icon = <ICON>;
			close (ICON);

			# Set the icon.
			$aim->set_icon (join ("",@icon));
			print "ChaosAIM: Buddy icon set!\n";
		}
		else {
			&panic ("$screenname bad buddy icon! Must be under 4 KB!",0);
		}
	}

	# Get our profile.
	open (PRO, "$chaos->{bots}->{$sn}->{profile}");
	my @profile = <PRO>;
	close (PRO);
	chomp @profile;
	my $prodata = join ("",@profile);

	# Chomp the profile down to size if it's too big.
	if (length $prodata > 1024) {
		my @chars = split(//, $prodata, 1024);
		$prodata = CORE::join ("", @chars);
		&panic ("Profile for $sn was exceeded 1024 char. limit! It has been truncated.");
	}

	# Get our buddy list.
	my %list;
	my $group;
	my $buddylist = $chaos->{bots}->{$sn}->{buddies};
	open (LIST, "$buddylist");
	my @list = <LIST>;
	close (LIST);
	chomp @list;
	foreach my $line (@list) {
		if ($line =~ /^\-\>/) {
			$group = $line;
		}
		else {
			$line =~ s/\-\> //g;
			$line =~ s/\-\>//g;
			$aim->add_buddy ($group,$line);
		}
	}

	# Load our chat room information.
	open (CHATS, $chaos->{bots}->{$sn}->{chats});
	my @chat = <CHATS>;
	close (CHATS);

	chomp @chat;

	if ($chat[0] == 0 || $chat[0] == 1) {
		# Go through the data.
		if ($chat[0] == 0) {
			$chaos->{bots}->{$sn}->{_chats}->{allow} = 0;
		}
		else {
			$chaos->{bots}->{$sn}->{_chats}->{allow} = 1;
		}

		foreach my $line (@chat) {
			next if length $line <= 1;
			my ($name,$autojoin,$leave) = split(/===/, $line, 3);

			next if length $autojoin > 1;
			next if length $leave > 1;

			# Load this data.
			my $ln = lc($name);
			$ln =~ s/ //g;
			$chaos->{bots}->{$sn}->{_chats}->{$ln}->{autojoin} = $autojoin;
			$chaos->{bots}->{$sn}->{_chats}->{$ln}->{leave} = $leave;

			# Autojoin Mode.
			if ($autojoin == 1) {
				# Join the room.
				&queue ($sn, 5, "\$chaos->{bots}->{'$sn'}->{client}->chat_join ('$name');");
			}
		}
	}
	else {
		&panic ("Improperly formatted chatroom datafile ($screenname)",0);
	}

	# Maintenance Mode on?
	if ($chaos->{system}->{maintain}->{on} == 1) {
		# Go away.
		$aim->set_away ('<body bgcolor="#000000" link="#FF0000"><font face="Verdana" size="2" color="#FFFF00">'
			. '<b>' . $chaos->{system}->{maintain}->{msg} . '</b></font></body>');
	}

	# Set our profile.
	$aim->set_info ($prodata);
	$aim->commit_buddylist ();
}
{
	Type        => 'handler',
	Name        => 'aim_signon_done',
	Description => 'Called when signon is complete.',
	Author      => 'Cerone Kirsle',
	Created     => '3:20 PM 11/20/2004',
	Updated     => '3:20 PM 11/20/2004',
	Version     => '1.0',
};