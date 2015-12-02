#      .   .               <Leviathan>
#     .:...::     Command Name // !promote
#    .::   ::.     Description // Promote a user.
# ..:;;. ' .;;:..        Usage // !promote <username>
#    .  '''  .     Permissions // Administrator Only.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub promote {
	my ($self,$client,$msg) = @_;

	# Must be an admin.
	return "This command may only be used by Administrators and higher!" unless &isAdmin($client);

	# Must have a message.
	return "Please provide a username to promote while using this command." unless length $msg > 0;

	# See that the username is formatted correctly.
	my ($listener,$user) = split(/\-/, $msg, 2);
	$listener = uc($listener);
	return "Invalid username: use the \"$chaos->{config}->{commandchar}help\" for information "
		. "on how a username is formatted." unless defined $user;

	# Format the target's name.
	my $name = $listener . '-' . $user;

	# Firstly, can't promote higher than Admin.
	return "You cannot promote a user higher than Admin." if &isAdmin($name);

	# Start promoting!
	if (&isMod($name)) {
		# Remove from Mod power.
		open (OPENMOD, "./data/authority/moderators.txt");
		my @mods = <OPENMOD>;
		close (OPENMOD);
		chomp @mods;

		my @newmods = ();
		foreach my $line (@mods) {
			next if $line eq $name;
			next if length $line == 0;
			push (@newmods, $line);
		}

		my $printed = CORE::join ("\n", @newmods);

		open (NEW, ">./data/authority/moderators.txt");
		print NEW $printed;
		close (NEW);

		# Promote to Admin.
		open (ADMIN, ">>./data/authority/administrators.txt");
		print ADMIN "\n$name";
		close (ADMIN);

		return "$name has been promoted to Administrator.";
	}
	else {
		# Promote to Moderator.
		open (MOD, ">>./data/authority/moderators.txt");
		print MOD "\n$name";
		close (MOD);

		return "$name has been promoted to Moderator.";
	}
}
{
	Restrict    => 'Administrators',
	Category    => 'Administrator Commands',
	Description => 'Promote a user.',
	Usage       => '!promote <username>',
	Listener    => 'All',
};