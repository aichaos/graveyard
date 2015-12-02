#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !menu
#    .::   ::.     Description // Shows the menu of commands.
# ..:;;. ' .;;:..        Usage // !menu [category]
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub menu {
	my ($self,$client,$msg,$listener) = @_;

	my $reply;

	# List of Categories (you'll have to update this list if you
	# add a custom category)
	my %cat = (
		a => ':: General Commands ::',
		1 => 'General',
		2 => 'Fun & Games',
		3 => 'Points Earning',
		4 => 'Random Stuff',
		5 => 'General Utilities',
		6 => 'Bot Utilities',
		7 => 'Feedback',
		b => ':: Higher-Level Commands ::',
		8 => 'Moderator Commands',
		9 => 'Administrator Commands',
		10 => 'Botmaster Commands',
	);
	# The order the categories are to go in (letter values are used as headers/dividers)
	my @order = (
		"a", 1, 2, 3, 4, 5, 6, 7, "b", 8, 9, 10,
	);

	# If a category has been chosen...
	if (length $msg > 0) {
		# Exiting?
		if (lc($msg) eq 'exit') {
			delete $chaos->{_users}->{$client}->{callback};
			return "Alright, we're done with the menu.";
		}

		# If it exists...
		if ((exists $cat{$msg} && $cat !~ /[^0-9]/) || ($msg eq "lost")) {
			my $category = $cat{$msg};

			# Array of commands.
			my @commands;
			my @lost;

			print "Debug // Msg: $msg\n"
				. "\t Category: $category\n";

			# Sort the keys.
			sort (keys %{$chaos->{_system}->{commands}});

			foreach my $key (keys %{$chaos->{_system}->{commands}}) {
				if (exists $chaos->{_system}->{commands}->{$key}->{Category} && $chaos->{_system}->{commands}->{$key}->{Category} eq $category) {
					# If this command has restricted access...
					if (exists $chaos->{_system}->{commands}->{$key}->{Restrict}) {
						my $restrict = $chaos->{_system}->{commands}->{$key}->{Restrict};

						# Restrictions are set.
						if ($restrict =~ /mod/i && isMod($client,$listener) == 0) {
							return "This category contains restricted commands that may only "
								. "be viewed by Moderators or higher.";
						}
						if ($restrict =~ /admin/i && isAdmin($client,$listener) == 0) {
							return "This category contains restricted commands that may only "
								. "be viewed by Administrators or higher.";
						}
						if ($restrict =~ /master/i && isMaster($client,$listener) == 0) {
							return "This category contains restricted commands that may only "
								. "be viewed by Botmasters.";
						}
					}

					# Use this command.
					push (@commands, $key);
				}
				else {
					# If it doesn't exist...
					if ($msg eq "lost" && !exists $chaos->{_system}->{commands}->{$key}->{Description}) {
						push (@lost, $key);
					}
				}
			}

			# Generate the reply.
			if ($msg eq "lost") {
				my $lostcmd = join ("\n", @lost);
				$reply = ":: Lost Commands ::\n"
					. "These commands are missing the hashref footers:\n\n"
					. "$lostcmd\n\n";
			}
			else {
				$reply = ":: $cat{$msg} ::\n\n";
				foreach my $cmd (@commands) {
					# Don't show hidden commands.
					if (!defined $chaos->{_system}->{commands}->{$cmd}->{Hidden}) {
						$reply .= $chaos->{_system}->{config}->{commandchar} . "$cmd - ";

						if (lc($chaos->{_system}->{commands}->{$cmd}->{Listener}) ne 'all') {
							$reply .= "($chaos->{_system}->{commands}->{$cmd}->{Listener}) ";
						}

						$reply .= $chaos->{_system}->{commands}->{$cmd}->{Description} . "\n";
					}
				}
			}
		}
		else {
			return "Invalid category. Type \'exit\' to exit the menu.";
		}
	}
	else {
		$chaos->{_users}->{$client}->{callback} = 'menu';

		$reply = "~ Main Menu ~\n\n"
			. "Type a number for a category listed below:\n";

		# Show the categories in correct order.
		foreach my $part (@order) {
			if ($part =~ /[A-Za-z]/i) {
				# Header.
				$reply .= "\n" . $cat{$part} . "\n";
			}
			else {
				# Category.
				$reply .= "$part :: $cat{$part}\n";
			}
		}
	}

	# Reply Footer.
	$reply .= "\nFor help with any commands, type !usage <lt>command<gt>";

	return $reply;
}

{
	Hidden => 1,
	Category => 'General',
	Description => 'Shows the Menu',
	Usage => '!menu [category]',
	Listener => 'All',
};