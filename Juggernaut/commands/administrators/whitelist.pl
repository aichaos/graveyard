#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !whitelist
#    .::   ::.     Description // WhiteList management.
# ..:;;. ' .;;:..        Usage // !whitelist <add|remove> <lis>-<username>
#    .  '''  .     Permissions // Admin Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub whitelist {
	my ($self,$client,$msg,$listener) = @_;

	# This command is Admin Only.
	if (isAdmin($client,$listener)) {
		# See that they have a request and a person's username.
		my ($request,$name) = split(/ /, $msg);
		my ($ul,$uc) = split(/\-/, $name, 2);
		$ul = uc($ul);
		$ul =~ s/ //g;
		$uc = lc($uc);
		$uc =~ s/ //g;

		if (length $request > 0) {
			if (length $ul > 0 && length $uc > 0) {
				# Process the request.
				$request = lc($request);
				$name = lc($name);
				$name =~ s/ //g;

				if ($request eq "add") {
					# Add somebody to the whitelist.
					open (WHITE, ">>./data/whitelist.txt");
					print WHITE "$ul-$uc\n";
					close (WHITE);

					return "I have added $name to the whitelist.";
				}
				elsif ($request eq "remove") {
					# Remove somebody from the whitelist.
					my $list;

					$ul = lc($ul);

					open (OLD, "./data/whitelist.txt");
					my @old = <OLD>;
					close (OLD);

					chomp @old;

					foreach my $line (@old) {
						$line = lc($line);
						$line =~ s/ //g;

						if ($line eq "$ul-$uc") {
							# Leave this out.
						}
						else {
							$list .= "$line\n";
						}
					}

					# Save the new list.
					open (NEW, ">./data/whitelist.txt");
					print NEW $list;
					close (NEW);

					return "I have removed $name from the whitelist.";
				}
				else {
					return "Invalid request. Valid requests are ADD or REMOVE.";
				}
			}
			else {
				return "You must specify a name to add or remove from the list.\n\n"
					. "!whitelist add listener-name\n"
					. "!whitelist remove listener-name";
			}
		}
		else {
			return "You must provide an action.\n\n"
				. "!whitelist add listener-name\n"
				. "!whitelist remove listener-name";
		}
	}
	else {
		return "This command is Admin Only.";
	}
}

{
	Restrict => 'Administrator',
	Category => 'Administrator Commands',
	Description => 'WhiteList Management',
	Usage => '!whitelist <add|remove> <listener>-<username>',
	Listener => 'All',
};