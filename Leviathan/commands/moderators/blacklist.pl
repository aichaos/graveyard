#      .   .               <Leviathan>
#     .:...::     Command Name // !blacklist
#    .::   ::.     Description // Blacklist Management.
# ..:;;. ' .;;:..        Usage // !copyright <add|remove> <username>
#    .  '''  .     Permissions // Moderator Only.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub blacklist {
	my ($self,$client,$msg) = @_;

	# Must be a moderator.
	return "This command may only be used by Moderators and higher!" unless &isMod($client);

	# Get data from the message.
	my ($message,$reason) = split(/:/, $msg, 2);
	my ($action,$user) = split(/ /, $message, 2);

	$reason =~ s/^\s//g;
	$user =~ s/\s$//g;

	# Make sure the action is right.
	return "Invalid action! Actions are: add, remove" unless ($action =~ /^(add|remove)$/i);

	# (Re) format the username.
	my ($sender,$nick) = split(/\-/, $user, 2);
	return "Improperly formatted username! Usernames look like: SENDER-username" unless defined $nick;
	$sender = uc($sender);
	$nick = lc($nick);
	$nick =~ s/ //g;
	$user = $sender . '-' . $nick;

	# Blacklist management.
	if ($action eq "add") {
		# Add.
		my $add = &modBlacklist ("add", $user, $reason);
		return "An error occurred while adding to the Blacklist!" if $add == 0;
		return "$user has been added to the Blacklist.";
	}
	elsif ($action eq "remove") {
		# Remove.
		my $remove = &modBlacklist ("remove", $user);
		return "An error occurred while removing from the Blacklist!" if $remove == 0;
		return "$user has been removed from the Blacklist.";
	}
	else {
		return "Unknown error.";
	}
}
{
	Restrict    => 'Moderators',
	Category    => 'Moderator Commands',
	Description => 'Blacklist Management.',
	Usage       => '!blacklist <add|remove> <username>',
	Listener    => 'All',
};