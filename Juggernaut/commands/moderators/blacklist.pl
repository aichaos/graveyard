#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !blacklist
#    .::   ::.     Description // Blacklist management.
# ..:;;. ' .;;:..        Usage // !blacklist <add|remove> <username>
#    .  '''  .     Permissions // Moderator Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub blacklist {
	my ($self,$client,$msg,$listener) = @_;

	# This command is Moderator Only.
	if (isMod($client,$listener)) {
		# See that they have a request and a person's username.
		my ($request,$name) = split(/ /, $msg);

		if (length $request > 0) {
			if (length $name > 0) {
				# Process the request.
				$request = lc($request);
				$name = lc($name);
				$name =~ s/ //g;

				if ($request eq "add") {
					# Add somebody to the blacklist.
					open (BLACK, ">>./data/blacklist.txt");
					print BLACK "$name\n";
					close (BLACK);

					return "I have added $name to the blacklist.";
				}
				elsif ($request eq "remove") {
					# Remove somebody from the blacklist.
					my $list;

					open (OLD, "./data/blacklist.txt");
					my @old = <OLD>;
					close (OLD);

					chomp @old;

					foreach my $line (@old) {
						$line = lc($line);
						$line =~ s/ //g;

						if ($line eq $name) {
							# Leave this out.
						}
						else {
							$list .= "$line\n";
						}
					}

					# Save the new list.
					open (NEW, ">./data/blacklist.txt");
					print NEW $list;
					close (NEW);

					return "I have removed $name from the blacklist.";
				}
				else {
					return "Invalid request. Valid requests are ADD or REMOVE.";
				}
			}
			else {
				return "You must specify a name to add or remove from the list.\n\n"
					. "!blacklist add name\n"
					. "!blacklist remove name";
			}
		}
		else {
			return "You must provide an action.\n\n"
				. "!blacklist add name\n"
				. "!blacklist remove name";
		}
	}
	else {
		return "This command is Moderator Only.";
	}
}

{
	Restrict => 'Moderator',
	Category => 'Moderator Commands',
	Description => 'Blacklist Management',
	Usage => '!blacklist <add|remove> <username>',
	Listener => 'All',
};