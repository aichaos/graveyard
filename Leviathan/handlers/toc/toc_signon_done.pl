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
# TOC Handler: signon_done
# Description: Called when signon is completed.

sub toc_signon_done {
	my ($aim,$evt,$from,$to) = @_;
	my $str = shift @{$evt->args};
	$aim->set_config_str ($str, 1);

	# Get localtime and username.
	my $stamp = &get_timestamp();
	my $sn = $aim->{botscreenname};
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Load the AIM profile.
	if (-e $chaos->{bots}->{$sn}->{profile}) {
		open (INFO, $chaos->{bots}->{$sn}->{profile});
		my @info = <INFO>;
		close (INFO);
		chomp @info;

		my $profile = CORE::join ("",@info);

		# Truncate if it's too big.
		if (length $profile > 1024) {
			my @chars = split(//, $profile, 1024);
			$profile = join ("",@chars);
			&panic ("Profile for $sn exceeded 1024 char. limit! It has been truncated.");
		}

		$aim->set_info ($profile);
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
			$aim->add_buddy (1,$group,$line);
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
				$aim->chat_join ($name);
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

	# Send configuration.
	$aim->send_config();
}
{
	Type        => 'handler',
	Name        => 'toc_signon_done',
	Description => 'Called when signon is completed.',
	Author      => 'Cerone Kirsle',
	Created     => '12:42 PM 2/6/2005',
	Updated     => '1:16 PM 2/6/2005',
	Version     => '1.0',
};