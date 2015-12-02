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
# AIM Handler: aim_signon_done
# Description: Called when signon is complete.

sub aim_signon_done {
	# Get variables from the server.
	my $aim = shift;

	# Get the local time and our screenname.
	my $time = localtime();
	my $screenname = $aim->screenname();

	# Format our screenname.
	$screenname = lc($screenname);
	$screenname =~ s/ //g;
	if ($chaos->{$screenname}->{format}) {
		$aim->format_screenname ($chaos->{$screenname}->{format});
	}

	# Set Buddy Icon
	if ($chaos->{$screenname}->{_oscar} eq '1.11') {
		print "ChaosAIM: Verifying buddy icon...\n";

		# Icon must be less than 4 KB.
		if (-s "$chaos->{$screenname}->{icon}" < 4000) {
			my $size = (-s "$chaos->{$screenname}->{icon}") / 1000;

			print "ChaosAIM: Loading buddy icon ($size KB)...\n";

			# Open the icon.
			open (ICON, "$chaos->{$screenname}->{icon}");
			binmode ICON;
			my @icon = <ICON>;
			close (ICON);

			# Set the icon.
			$aim->set_icon (join ("", @icon));
			print "ChaosAIM: Buddy icon set!\n";
		}
		else {
			&panic ("$screenname bad buddy icon! Must be under 4 KB!",0);
		}
	}

	# Get our profile.
	my $profile = $chaos->{$screenname}->{profile};
	open (PRO, "$profile");
	my @profile = <PRO>;
	close (PRO);
	chomp @profile;

	my $prodata;
	foreach $line (@profile) {
		$prodata .= "$line";
	}

	# Get our buddy list.
	my %list;  # A temporary hash.
	my $group; # A temporary variable.
	my $buddylist = $chaos->{$screenname}->{buddies};
	open (LIST, "$buddylist");
	my @list = <LIST>;
	close (LIST);
	chomp @list;
	foreach $line (@list) {
		if ($line !~ /\-\>/) {
			$group = $line;
		}
		else {
			$line =~ s/\-\> //g;
			$line =~ s/\-\>//g;
			$aim->add_buddy ($group, $line);
		}
	}

	# Load our chat room information.
	if (exists $chaos->{$screenname}->{chats}) {
		open (CHATS, $chaos->{$screenname}->{chats});
		my @chat = <CHATS>;
		close (CHAT);

		chomp @chat;

		if ($chat[0] == 0 || $chat[0] == 1) {
			# Go through the chat data.
			if ($chat[0] == 0) {
				$chaos->{$screenname}->{_chats}->{allow} = 0;
			}
			else {
				$chaos->{$screenname}->{_chats}->{allow} = 1;
			}

			foreach my $line (@chat) {
				if (length $line > 1) {
					my ($name,$autojoin,$leave) = split(/===/, $line, 3);

					next if length $autojoin > 1;
					next if length $leave > 1;

					# Load this data into the hash.
					my $ln = lc($name);
					$ln =~ s/ //g;
					$chaos->{$screenname}->{_chats}->{$ln}->{autojoin} = $autojoin;
					$chaos->{$screenname}->{_chats}->{$ln}->{leave} = $leave;

					# Autojoin mode.
					if ($autojoin == 1) {
						# Join the room.
						$aim->chat_join ($name);
					}
				}
			}
		}
		else {
			&panic ("Improperly formatted chatroom datafile ($screenname).", 0);
		}
	}

	# Maintenance mode on?
	if ($chaos->{_system}->{maintain}->{on} eq '1') {
		# Go away.
		$aim->set_away ('<body bgcolor="#000000" link="#FF0000"><font face="Verdana" size="2" color="#FFFF00"><b>' . $chaos->{_system}->{maintain}->{msg} . '</b></font></body>');
	}

	# Set our profile.
	$aim->set_info ($prodata);
	$aim->commit_buddylist();
}
1;