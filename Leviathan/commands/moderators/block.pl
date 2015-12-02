#      .   .               <Leviathan>
#     .:...::     Command Name // !block
#    .::   ::.     Description // Blocks a user temporarily.
# ..:;;. ' .;;:..        Usage // !block <username>
#    .  '''  .     Permissions // Moderator Only.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub block {
	my ($self,$client,$msg) = @_;

	# Must be a moderator.
	return "This command may only be used by Moderators and higher!" unless &isMod($client);

	return "You must give me a user to block while using this command!" unless length $msg > 0;

	# (Re) format the username.
	my ($sender,$nick) = split(/\-/, $msg, 2);
	return "Improperly formatted username! Usernames look like: SENDER-username" unless defined $nick;
	$sender = uc($sender);
	$nick = lc($nick);
	$nick =~ s/ //g;
	$user = $sender . '-' . $nick;

	# Block them.
	my $expire = &system_block ($user,1);

	# Return.
	return "$user has been blocked for $expire minutes.";
}
{
	Restrict    => 'Moderators',
	Category    => 'Moderator Commands',
	Description => 'Temporarily block a user.',
	Usage       => '!block <username>',
	Listener    => 'All',
};