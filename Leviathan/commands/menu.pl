#      .   .               <Leviathan>
#     .:...::     Command Name // !menu
#    .::   ::.     Description // Shows the menu of commands.
# ..:;;. ' .;;:..        Usage // !menu [category]
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2005 AiChaos Inc.

sub menu {
	my ($self,$client,$msg) = @_;

	# Get all the categories.
	my %cats;
	my %counts = (
		'Moderator Commands' => 0,
		'Administrator Commands' => 0,
		'Botmaster Commands' => 0,
	);
	my $place = 1;
	my $found = 0;
	my @allcats = ();
	foreach my $cmd (keys %{$chaos->{system}->{commands}}) {
		if (exists $chaos->{system}->{commands}->{$cmd}->{Category}) {
			my $category = $chaos->{system}->{commands}->{$cmd}->{Category};

			if ($category =~ /botmaster/i) {
				$counts{'Botmaster Commands'}++;
				next;
			}
			if ($category =~ /admin/i) {
				$counts{'Administrator Commands'}++;
				next;
			}
			if ($category =~ /moderator/i) {
				$counts{'Moderator Commands'}++;
				next;
			}

			# Reserved categories.
			next if $category =~ /^(botmaster|administrator|moderator) commands$/i;

			$found = 0;

			foreach my $exists (@allcats) {
				if ($exists eq $category) {
					$counts{$category}++;
					$found = 1;
				}
			}

			unless ($found) {
				$counts{$category} = 1;
				push (@allcats, $category);
			}
		}
	}

	my @sortcats = sort { $a cmp $b } @allcats;
	foreach my $sort (@sortcats) {
		$cats{$place} = $sort;
		$place++;
	}

	# (Re)add restricted categories.
	$cats{$place} = 'Moderator Commands'; $place++;
	$cats{$place} = 'Administrator Commands'; $place++;
	$cats{$place} = 'Botmaster Commands';

	# Sort the category.
	my @allkeys = keys %cats;
	my @keys = sort { $a cmp $b } @allkeys;

	my $reply;

	# Sending a message...
	if (length $msg > 0) {
		# Exiting?
		if (lc($msg) =~ /^exit/i) {
			# Exit.
			delete $chaos->{clients}->{$client}->{callback};
			return "Alright, you have exited the menu.";
		}

		# If it exists...
		if (exists $cats{$msg} && $cat !~ /[^0-9]/i) {
			my $incat = $cats{$msg};

			# Array of commands.
			my @list = ();

			# Go through the commands.
			foreach my $vis (keys %{$chaos->{system}->{commands}}) {
				if (exists $chaos->{system}->{commands}->{$vis}->{Category} && $chaos->{system}->{commands}->{$vis}->{Category} eq $incat) {
					# Restricted command?
					my $restrict = $chaos->{system}->{commands}->{$vis}->{Restrict} || '';

					# Restrictions are set...
					if ($restrict =~ /mod/i && &isMod($client) == 0) {
						return "This category contains restricted commands that may "
							. "only be viewed by Moderators or higher.";
					}
					if ($restrict =~ /admin/i && &isAdmin($client) == 0) {
						return "This category contains restricted commands that may "
							. "only be viewed by Administrators or higher.";
					}
					if ($restrict =~ /master/i && &isMaster($client) == 0) {
						return "This category contains restricted commands that may "
							. "only be viewed by Botmasters.";
					}

					# Use this command.
					push (@list, $vis);
				}
			}

			my @show = sort { $a cmp $b } @list;

			$reply = ":: $cats{$msg} ::\n\n";
			foreach my $display (@show) {
				# Don't show hidden commands.
				if (!defined $chaos->{system}->{commands}->{$display}->{Hidden}) {
					$reply .= $chaos->{config}->{command} . "$display - ";

					# Restricted to a messenger?
					if (lc($chaos->{system}->{commands}->{$display}->{Listener}) ne 'all') {
						$reply .= "($chaos->{system}->{commands}->{$display}->{Listener}) ";
					}

					$reply .= "$chaos->{system}->{commands}->{$display}->{Description}\n";
				}
			}

			$reply .= "\nType !usage <lt>command<gt> for help with a command.";
		}
		else {
			$reply = "Invalid category. Type \"exit\" to exit the menu.";
		}
	}
	else {
		# Set the callback.
		$chaos->{clients}->{$client}->{callback} = 'menu';

		# Give the menu.
		$reply = "~ Main Menu ~\n\n"
			. "Type a number for a category listed below (i.e. 4) to see the "
			. "commands in that category:\n\n"
			. ":: Commands Menu ::\n";

		for (my $i = 1; exists $cats{$i}; $i++) {
			$reply .= "$i - $cats{$i}\n";
		}
	}

	# Return the reply.
	return $reply;
}
{
	# Hidden => 1,
	Category => 'General',
	Description => 'Shows the Menu',
	Usage => '!menu [category]',
	Listener => 'All',
};