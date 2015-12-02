#      .   .               <Leviathan>
#     .:...::     Command Name // !warnlist
#    .::   ::.     Description // Warners List Management.
# ..:;;. ' .;;:..        Usage // !warnlist <add|remove> <username>
#    .  '''  .     Permissions // Moderator Only.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub warnlist {
	my ($self,$client,$msg) = @_;

	# Must be a moderator.
	return "This command may only be used by Moderators and higher!" unless &isMod($client);

	# Get data from the message.
	my ($action,$user) = split(/ /, $msg, 2);

	$reason =~ s/\s//g;
	$user =~ s/\s//g;

	# Make sure the action is right.
	return "Invalid action! Actions are: add, remove" unless ($action =~ /^(add|remove)$/i);

	# (Re) format the username.
	my ($sender,$nick) = split(/\-/, $user, 2);
	return "Improperly formatted username! Usernames look like: SENDER-username" unless defined $nick;
	$sender = uc($sender);
	$nick = lc($nick);
	$nick =~ s/ //g;
	$user = $sender . '-' . $nick;

	# Only for AIM and TOC.
	if ($sender ne 'AIM' && $sender ne 'TOC') {
		return "Only AIM and TOC users can be put on the warners list (warnings are an AIM-specific function!)";
	}

	# Warnlist management.
	if ($action eq "add") {
		# Add.
		my $add = &modWarnlist ("add", $user, $reason);
		return "An error occurred while adding to the Warnlist!" if $add == 0;
		return "$user has been added to the Warnlist.";
	}
	elsif ($action eq "remove") {
		# Remove.
		my $remove = &modWarnlist ("remove", $user);
		return "An error occurred while removing from the Warnlist!" if $remove == 0;
		return "$user has been removed from the Warnlist.";
	}
	else {
		return "Unknown error.";
	}
}
{
	Restrict    => 'Moderators',
	Category    => 'Moderator Commands',
	Description => 'Warners List Management.',
	Usage       => '!warnlist <add|remove> <username>',
	Listener    => 'All',
};