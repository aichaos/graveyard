#      .   .               <Leviathan>
#     .:...::     Command Name // !reload
#    .::   ::.     Description // Reload the bot's files and replies.
# ..:;;. ' .;;:..        Usage // !reload
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2005 AiChaos Inc.

sub reload {
	my ($self,$client,$msg) = @_;

	# Master-only.
	return "This command may only be used by my master!" unless &isMaster($client);

	# Must have some data to reload.
	return "Give me something to reload! That can be either of these options:\n\n"
		. "commands, handlers, subroutines, brains, all" unless length $msg > 0;
	$msg = lc($msg);
	$msg =~ s/ //g;

	return "Invalid option! Valid options are: commands, handlers, brains, or all"
		unless $msg =~ /^(commands|handlers|subroutines|brains|all)$/i;

	print ":: Reloading configuration file...\n";
	do "./config/settings.cfg";

	print ":: Reloading substitution data...\n";
	open (SUBS, "./data/substitution.dat");
	my @subs = <SUBS>;
	close (SUBS);
	chomp @subs;
	foreach my $line (@subs) {
		next if length $line == 0;
		next if $line =~ /^\#/;

		my ($level,$in,$out) = split(/==/, $line, 3);

		$chaos->{system}->{substitution}->{$in}->{level} = $level;
		$chaos->{system}->{substitution}->{$in}->{replace} = $out;
	}

	print ":: Reloading Perl files...\n";
	my @resdirs = (
		"1=./brains",
		"0=./clients",
		"0=./commands",
		"0=./config",
		"0=./data",
		"1=./handlers/aim",
		"1=./handlers/msn",
		"1=./handlers/irc",
		"1=./handlers/jabber",
		"1=./handlers/http",
		"0=./logs",
		"1=./subroutines",
	);
	foreach my $folder (@resdirs) {
		# Get data on this folder.
		my ($useperl,$name) = split(/=/, $folder, 2);
		&panic ("Missing required directory $name",1) unless (-e $name);

		# Get the directory type.
		my $dirtype;
		$dirtype = "subroutines" if $name eq './subroutines';
		$dirtype = "handlers" if $name =~ /^\.\/handlers/i;
		$dirtype = "brains" if $name eq './brains';
		$dirtype = "void" if $name =~ /^\.\/(bots|clients|commands|config|data|logs)/i;
		&panic ("Unknown directory type: $name",0) unless length $dirtype > 0;

		# Don't reload this unless we have to.
		if ($msg ne 'all') {
			if ($dirtype ne $msg) {
				next;
			}
		}

		# If a Perl directory...
		if ($useperl == 1) {
			opendir (DIR, $name);
			foreach my $file (sort(grep(!/^\./, readdir(DIR)))) {
				# Get our Perl file extensions...
				my $perlext = $chaos->{config}->{files}->{perl};
				if ($file =~ /\.($perlext)$/i) {
					# Include it!
					print "\tIncluding $name/$file... ";
					my $fname = $file;
					$fname =~ s/\.($perlext)$//i if $dirtype eq 'brains';
					$chaos->{system}->{$dirtype}->{$fname} = do "$name/$file";
					print "Done!\n";
				}
			}
			closedir (DIR);
		}
	}

	# Reload commands and replies.
	if ($msg eq 'all' || $msg eq 'commands') {
		print ":: Indexing Commands...\n";
		&load_commands();
	}

	# Reload brains.
	if ($msg eq 'all' || $msg eq 'brains') {
		foreach my $bot (keys %{$chaos->{bots}}) {
			my $brain = $chaos->{bots}->{$bot}->{brain};
			my $reply = $chaos->{bots}->{$bot}->{replies};
			&load_brain ($bot,$brain,$reply);
		}
	}

	# Redefine bots' handlers.
	if ($msg eq 'all' || $msg eq 'handlers') {
		print ":: Redefining Handlers...\n";
		foreach my $key (keys %{$chaos->{bots}}) {
			my $listener = $chaos->{bots}->{$key}->{listener};

			next unless exists $chaos->{bots}->{$key}->{client};

			# Define handlers.
			if ($listener eq 'AIM') {
				# Setup all the AIM handlers.
				$chaos->{bots}->{$key}->{client}->set_callback_admin_error (\&aim_admin_error);
				$chaos->{bots}->{$key}->{client}->set_callback_admin_ok (\&aim_admin_ok);
				$chaos->{bots}->{$key}->{client}->set_callback_auth_challenge (\&aim_auth_challenge);
				$chaos->{bots}->{$key}->{client}->set_callback_buddy_in (\&aim_buddy_in);
				$chaos->{bots}->{$key}->{client}->set_callback_buddy_info (\&aim_buddy_info);
				$chaos->{bots}->{$key}->{client}->set_callback_buddy_out (\&aim_buddy_out);
				$chaos->{bots}->{$key}->{client}->set_callback_buddylist_error (\&aim_buddylist_error);
				$chaos->{bots}->{$key}->{client}->set_callback_buddylist_ok (\&aim_buddylist_ok);
				$chaos->{bots}->{$key}->{client}->set_callback_chat_buddy_in (\&aim_chat_buddy_in);
				$chaos->{bots}->{$key}->{client}->set_callback_chat_buddy_out (\&aim_chat_buddy_out);
				$chaos->{bots}->{$key}->{client}->set_callback_chat_closed (\&aim_chat_joined);
				$chaos->{bots}->{$key}->{client}->set_callback_chat_im_in (\&aim_chat_im_in);
				$chaos->{bots}->{$key}->{client}->set_callback_chat_invite (\&aim_chat_invite);
				$chaos->{bots}->{$key}->{client}->set_callback_chat_joined (\&aim_chat_joined);
				$chaos->{bots}->{$key}->{client}->set_callback_error (\&aim_error);
				$chaos->{bots}->{$key}->{client}->set_callback_evil (\&aim_evil);
				$chaos->{bots}->{$key}->{client}->set_callback_im_in (\&aim_im_in);
				$chaos->{bots}->{$key}->{client}->set_callback_rate_alert (\&aim_rate_alert);
				$chaos->{bots}->{$key}->{client}->set_callback_signon_done (\&aim_signon_done);
				$chaos->{bots}->{$key}->{client}->set_callback_new_buddy_icon (\&aim_new_buddy_icon);
				$chaos->{bots}->{$key}->{client}->set_callback_buddy_icon_uploaded (\&aim_buddy_icon_uploaded);
				$chaos->{bots}->{$key}->{client}->set_callback_buddy_icon_downloaded (\&aim_buddy_icon_downloaded);
				$chaos->{bots}->{$key}->{client}->set_callback_typing_status (\&aim_typing_status);
			}
			elsif ($listener eq 'MSN') {
				# Setup MSN handlers.
				$chaos->{bots}->{$key}->{client}->setHandler (Connected             => \&msn_connected);
				$chaos->{bots}->{$key}->{client}->setHandler (Disconnected          => \&msn_disconnect);
				$chaos->{bots}->{$key}->{client}->setHandler (ClientCaps            => \&msn_clientcaps);
				$chaos->{bots}->{$key}->{client}->setHandler (ContactAddingUs       => \&msn_add);
				$chaos->{bots}->{$key}->{client}->setHandler (ContactRemovingUs     => \&msn_remove);
				$chaos->{bots}->{$key}->{client}->setHandler (Message               => \&msn_message);
				$chaos->{bots}->{$key}->{client}->setHandler (Typing                => \&msn_typing);
				$chaos->{bots}->{$key}->{client}->setHandler (Ring                  => \&msn_ring);
				$chaos->{bots}->{$key}->{client}->setHandler (Answer                => \&msn_answer);
				$chaos->{bots}->{$key}->{client}->setHandler (MemberJoined          => \&msn_join);
				$chaos->{bots}->{$key}->{client}->setHandler (RoomClosed            => \&msn_close);
				$chaos->{bots}->{$key}->{client}->setHandler (FileReceiveInvitation => \&msn_file);
			}
			elsif ($listener eq 'YAHOO') {
				$chaos->{bots}->{$key}->{client}->setHandler (Connected => \&yahoo_connected);
				$chaos->{bots}->{$key}->{client}->setHandler (Message   => \&yahoo_message);
			}
			elsif ($listener eq 'IRC') {
				# Set up IRC handlers.
				$chaos->{bots}->{$key}->{_conn}->add_handler ('msg', \&irc_pm);
				$chaos->{bots}->{$key}->{_conn}->add_handler ('chat', \&irc_chat);
				$chaos->{bots}->{$key}->{_conn}->add_handler ('public', \&irc_public);
				$chaos->{bots}->{$key}->{_conn}->add_handler ('caction', \&irc_action);
				$chaos->{bots}->{$key}->{_conn}->add_handler ('umode', \&irc_umode);
				$chaos->{bots}->{$key}->{_conn}->add_handler ('cdcc', \&irc_dcc);
				$chaos->{bots}->{$key}->{_conn}->add_handler ('topic', \&irc_topic);
				$chaos->{bots}->{$key}->{_conn}->add_handler ('notopic', \&irc_topic);

				$chaos->{bots}->{$key}->{_conn}->add_global_handler ([ 251,252,253,254,302,255 ], \&irc_init);
				$chaos->{bots}->{$key}->{_conn}->add_global_handler ('disconnect', \&irc_disconnect);
				$chaos->{bots}->{$key}->{_conn}->add_global_handler (376, \&irc_connect);
				$chaos->{bots}->{$key}->{_conn}->add_global_handler (433, \&irc_nick_taken);
				$chaos->{bots}->{$key}->{_conn}->add_global_handler (353, \&irc_names);
			}
			elsif ($listener eq 'TOC') {
				# Set handlers.
				my $conn = $chaos->{bots}->{$key}->{client}->getconn;
				$conn->set_handler ('error', \&toc_error);
				$conn->set_handler ('im_in', \&toc_im_in);
				$conn->set_handler ('eviled', \&toc_evil);
				$conn->set_handler ('config', \&toc_signon_done);
				$conn->set_handler ('chat_join', \&toc_chat_join);
				$conn->set_handler ('chat_invite', \&toc_chat_invite);
				$conn->set_handler ('chat_update_buddy', \&toc_chat_update_buddy);
				$conn->set_handler ('chat_in', \&toc_chat_im_in);
				$conn->set_handler ('update_buddy', \&toc_update_buddy);
			}
			elsif ($listener eq 'CYAN') {
				# Set up handlers.
				$chaos->{bots}->{$key}->{client}->setHandler (Connected        => \&cyan_connected);
				$chaos->{bots}->{$key}->{client}->setHandler (Welcome          => \&cyan_welcome);
				$chaos->{bots}->{$key}->{client}->setHandler (Message          => \&cyan_message);
				$chaos->{bots}->{$key}->{client}->setHandler (Private          => \&cyan_private);
				$chaos->{bots}->{$key}->{client}->setHandler (Ignored          => \&cyan_ignored);
				$chaos->{bots}->{$key}->{client}->setHandler (Chat_Buddy_In    => \&cyan_buddy_in);
				$chaos->{bots}->{$key}->{client}->setHandler (Chat_Buddy_Out   => \&cyan_buddy_out);
				$chaos->{bots}->{$key}->{client}->setHandler (Chat_Buddy_Here  => \&cyan_buddy_here);
				$chaos->{bots}->{$key}->{client}->setHandler (Name_Accepted    => \&cyan_name_accepted);
				$chaos->{bots}->{$key}->{client}->setHandler (Error            => \&cyan_error);
			}
			elsif ($listener eq 'JABBER') {
				# Set callbacks.
				my $jabber = $chaos->{bots}->{$key}->{client};
				$chaos->{bots}->{$key}->{client}->SetMessageCallBacks (chat => sub { &jabber_message ($jabber,$key,@_); });
			}
			else {
				next;
			}
		}
	}

	return "Bot reloaded successfully!";
}
{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Reload the bot.',
	Usage => '!reload',
	Listener => 'All',
};