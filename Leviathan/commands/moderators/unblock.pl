#      .   .               <Leviathan>
#     .:...::     Command Name // !unblock
#    .::   ::.     Description // Unblock a temporarily-banned user.
# ..:;;. ' .;;:..        Usage // !unblock <username>
#    .  '''  .     Permissions // Moderator Only.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub unblock {
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

	# Remove the block.
	&profile_send ($user,'Blocked','0');
	&profile_send ($user,'Expire','0');

	# Return.
	return "$user has been unblocked.";
}
{
	Restrict    => 'Moderators',
	Category    => 'Moderator Commands',
	Description => 'Unblock a temporarily-banned user.',
	Usage       => '!unblock <username>',
	Listener    => 'All',
};