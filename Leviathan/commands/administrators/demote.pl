#      .   .               <Leviathan>
#     .:...::     Command Name // !demote
#    .::   ::.     Description // Demote a user.
# ..:;;. ' .;;:..        Usage // !demote <username>
#    .  '''  .     Permissions // Administrator Only.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub demote {
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

	# Firstly, can't demote lower than normal.
	return "That user is demoted as far as he can be." if !&isMod($name);

	if (&isMaster($name)) {
		return "$name is a botmaster; you cannot change that.";
	}

	# Get the file to demote from.
	my $file;
	$file = 'moderators.txt' if &isMod($name);
	$file = 'administrators.txt' if &isAdmin($name);
	my $from = $file;
	$from =~ s/\.txt$//ig;
	$from = ucfirst($from);

	if (defined $file) {
		my $level = "a normal user";
		$level = "Moderator" if &isAdmin($name);

		open (FILE, "./data/authority/$file");
		my @data = <FILE>;
		close (FILE);
		chomp @data;

		my @new = ();
		foreach my $line (@data) {
			next if $line eq $name;
			next if length $line == 0;
			push (@new, $line);
		}

		open (NEW, ">./data/authority/$file");
		print NEW join ("\n", @new);
		close (NEW);

		# If demoted from Admin, promote to Moderator.
		if ($file =~ /^admin/i) {
			&promote ($self,$client,$msg);
		}

		return "$name has been removed from $from group, to $level.";
	}
	else {
		return "Unknown error: filename undefined!";
	}
}
{
	Restrict    => 'Administrators',
	Category    => 'Administrator Commands',
	Description => 'Demote a user.',
	Usage       => '!demote <username>',
	Listener    => 'All',
};