# COMMAND NAME:
#	INFO
# DESCRIPTION:
#	Displays info on becoming promoted.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub info {
	my ($self,$client,$msg,$listener) = @_;

	# See if they want information about any specific position.
	if ($msg) {
		$msg = lc($msg);
		my $desire;

		$desire = "Client" if $msg eq "client";
		$desire = "Gifted" if $msg eq "gifted";
		$desire = "Keeper" if $msg eq "keeper";
		$desire = "Moderator" if $msg eq "moderator";
		$desire = "Super Moderator" if $msg eq "super moderator";
		$desire = "Admin" if $msg eq "admin";
		$desire = "Super Admin" if $msg eq "super admin";

		if ($desire) {
			# Get them their info.
			if ($desire eq "Client") {
				$reply = "<b>Client Information</b>\n\n"
					. "All new users who IM the bot for the first time "
					. "are automatically put into the Client category. "
					. "Clients can use all the public commands.";
			}
			elsif ($desire eq "Gifted") {
				$reply = "<b>Gifted Information</b>\n\n"
					. "Clients are promoted to Gifted usually after doing "
					. "something for the botmaster. This could be contributing "
					. "a useful command or for being the bot's number 1 client, "
					. "for example. Gifted users have access to more commands "
					. "than Clients, however being Gifted is only temporary.";
			}
			elsif ($desire eq "Keeper") {
				$reply = "<b>Keeper Information</b>\n\n"
					. "Keepers are robots (or humans) who are programmed to "
					. "work with this robot. Keepers have access only to "
					. "certain commands that are required to keep the bot "
					. "online and healthy.";
			}
			elsif ($desire eq "Moderator") {
				$reply = "<b>Moderator Information</b>\n\n"
					. "Moderators are the first level of authority in this bot. "
					. "Moderators have the power to add or remove users of any "
					. "messenger to the blocked and warners lists. Moderators "
					. "also have the power to view the User Info of any user. "
					. "User Info contains such things as a user's permissions, "
					. "message counts, and information they taught the bot such as "
					. "their name or age.";
			}
			elsif ($desire eq "Super Moderator") {
				$reply = "<b>Super Mod Information</b>\n\n"
					. "Super Moderators have more power than normal Moderators. "
					. "Super Mods have access to commands that will change the bot's "
					. "online status (eg. away or idle). Super Mods also have "
					. "access to MSN Messenger's !alert command to broadcast a message "
					. "to all users who have the bot on their contact list.";
			}
			elsif ($desire eq "Admin") {
				$reply = "<b>Admin Information</b>\n\n"
					. "Admin users have the power (on MSN) to list or join open "
					. "sockets (conversations).";
			}
			elsif ($desire eq "Super Admin") {
				$reply = "<b>Super Admin Information</b>\n\n"
					. "Super Admins have the power (on MSN) to list, join, or "
					. "terminate open sockets (conversations).";
			}
			elsif ($desire eq "Master") {
				$reply = "<b>Master Information</b>\n\n"
					. "The Master is usually the owner of the bot. The Master "
					. "has access to commands that can execute functions on "
					. "the computer the bot is running on, as well as execute "
					. "Perl functions and reload the bot's files.";
			}
		}
		else {
			$reply = "Invalid position. Valid positions are:\n"
				. "Client, Gifted, Keeper, Moderator, "
				. "Super Moderator, Admin, Super Admin, Master.";
		}
	}
	else {
		$reply = "Correct usage is: !info [position]\n\n"
			. "Valid positions are:\n"
			. "Client, Gifted, Keeper, Moderator, Super Moderator, Admin, Super Admin.";
	}

	return $reply;
}
1;