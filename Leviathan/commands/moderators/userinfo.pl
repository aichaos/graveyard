#      .   .               <Leviathan>
#     .:...::     Command Name // !userinfo
#    .::   ::.     Description // Gets all information about a user.
# ..:;;. ' .;;:..        Usage // !userinfo <username>
#    .  '''  .     Permissions // Moderator Only.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub userinfo {
	my ($self,$client,$msg) = @_;

	# Must be a moderator.
	return "This command may only be used by Moderators and higher!" unless &isMod($client);

	return "You must give me a user to unblock while using this command!" unless length $msg > 0;

	# (Re) format the username.
	my ($sender,$nick) = split(/\-/, $msg, 2);
	return "Improperly formatted username! Usernames look like: SENDER-username" unless defined $nick;
	$sender = uc($sender);
	$nick = lc($nick);
	$nick =~ s/ //g;
	$user = $sender . '-' . $nick;

	# Get their info.
	open (INFO, "./clients/$user\.txt") or return "User info could not be retrieved: profile doesn't exist!";
	my @info = <INFO>;
	close (INFO);
	chomp @info;

	my %profile;

	foreach my $line (@info) {
		my ($what,$is) = split(/=/, $line, 2);
		$what = lc($what);
		$what =~ s/ //g;

		$profile{$what} = $is;
	}

	# If not temporarily blocked, yes for blacklisted.
	if ($profile{blocked} ne '1') {
		if (&isBlocked ($user)) {
			$profile{blocked} = '1';
		}
	}

	# Prepare the response.
	my $reply = "User Info for $user\n\n"
		. ":: Basics\n";

	foreach my $basic (keys %profile) {
		next if $basic =~ /points|stars|blocked|blocks|exmins|expire/i;
		next if length $basic == 0;
		next if $basic =~ /^\//i;
		$reply .= "$basic: $profile{$basic}\n";
	}

	$reply .= "\n"
		. ":: Status Details\n"
		. "Points: $profile{points}\n"
		. "Stars: $profile{stars}\n";
	$reply .= "Blocked: Yes\n" if $profile{blocked} eq '1';
	$reply .= "Blocked: No\n" if $profile{blocked} ne '1';

	# See if they're blocked.
	my ($block,$reason) = &isBlocked ($user);

	# Temporary?
	my $length = 0;
	if ($reason =~ /temporary block: (.*?) minutes remaining/i) {
		$length = "$1 minutes";
	}
	elsif ($reason =~ /permanent ban/i) {
		$length = 'never';
	}
	else {
		$length = 'n/a';
	}

	$reply .= "Times Blocked: $profile{blocks}\n"
		. "Block Expires: $length";

	# Return.
	return $reply;
}
{
	Restrict    => 'Moderators',
	Category    => 'Moderator Commands',
	Description => 'Gets all information about a user.',
	Usage       => '!userinfo <username>',
	Listener    => 'All',
};