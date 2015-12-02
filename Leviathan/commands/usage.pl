#      .   .               <Leviathan>
#     .:...::     Command Name // !usage
#    .::   ::.     Description // Get the usage of a command.
# ..:;;. ' .;;:..        Usage // !usage <command>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub usage {
	my ($self,$client,$msg) = @_;

	# Must have a message.
	return "Give me a command to check when using this command, i.e.\n\n"
		. "!usage menu" unless length $msg > 0;

	# Strip the command char off (if they included it).
	my $char = $chaos->{config}->{command};
	$msg =~ s/^$char//ig;

	# Format the command.
	$msg = lc($msg);
	$msg =~ s/ //g;

	# Get information on this command.
	if (exists $chaos->{system}->{commands}->{$msg}) {
		my $hidden = $chaos->{system}->{commands}->{$msg}->{Hidden} || 0;
		my $restrict = $chaos->{system}->{commands}->{$msg}->{Restrict} || '';
		my $category = $chaos->{system}->{commands}->{$msg}->{Category};
		my $description = $chaos->{system}->{commands}->{$msg}->{Description};
		my $usage = $chaos->{system}->{commands}->{$msg}->{Usage};
		my $listener = $chaos->{system}->{commands}->{$msg}->{Listener};

		# Restricted?
		if (length $restrict > 0) {
			if ($restrict =~ /mod/i) {
				return "This command is for Moderators' eyes only!" unless &isMod($client);
			}
			elsif ($restrict =~ /admin/i) {
				return "This command is for Admins' eyes only!" unless &isAdmin($client);
			}
			else {
				return "This command is for Botmasters' eyes only!" unless &isMaster($client);
			}
		}

		# Hidden?
		return "I don't have any information about that command." if $hidden;

		# Filter things.
		$usage =~ s/\</&lt;/ig;
		$usage =~ s/\>/&gt;/ig;

		# Return the information.
		return "Command: $char" . "$msg\n\n"
			. "Category: $category\n"
			. "Description: $description\n"
			. "Listeners: $listener\n\n"
			. "Usage: $usage";
	}
	else {
		return "I don't have any information about that command.";
	}
}

{
	Category => 'General',
	Description => 'Get the usage of a command.',
	Usage => '!usage <command>',
	Listener => 'All',
};