# COMMAND NAME:
#	ADMIN
# DESCRIPTION:
#	Administrator controls
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub admin {
	# Get strings from the shift.
	my ($client,$msg,$self) = @_;

	# Cut off the command.
	$msg =~ s/\!admin //ig;

	# First, make sure they're an Admin.
	if (isAdmin($client)) {
		# Admin Commands:
		# !admin mod <username>     => Add to Moderators list.
		# !admin demod <username>   => Remove from Mod list.
		# !admin admin <username>   => Add to Admin list.
		# !admin deadmin <username> => Remove from Admin list.

		# Get the command and arguments.
		my ($command,@args) = split(/ /, $msg);
		my $args = join(/ /, @args);

		# Go through each command.
		if ($command eq "mod") {
			# Add a moderator.
			open (MODS, ">>./data/authority/mods.txt");
			print MODS "$args\n";
			close (MODS);

			$reply = "I have added $args to the Moderator list.";
		}
		elsif ($command eq "demod") {
			# Unblock a user.
			open (OLD, "data/authority/mods.txt");
			my @mods = <OLD>;
			close (OLD);

			# Go through each line.
			my $new_list;
			foreach $line (@mods) {
				chomp $line;
				$line =~ s/ //g;
				$line = lc($line);
				$args =~ s/ //g;
				$args = lc($args);

				if ($line eq $args) {
					$line = "";
				}
				else {
					$line = "$line\n";
				}

				# Save the new list.
				$new_list .= "$line";
			}

			# Save the list.
			open (NEW, ">./data/authority/mods.txt");
			print NEW $new_list;
			close (NEW);

			$reply = "I have removed Moderator priviledges for $args.";
		}
		elsif ($command eq "admin") {
			# Add user to Admins list.
			open (LIST, ">>./data/authority/admin.txt");
			print LIST "$args\n";
			close (LIST);

			$reply = "I have promoted $args to Admin.";
		}
		elsif ($command eq "deadmin") {
			# Remove an Admin.
			open (OLD, "data/authority/admin.txt");
			my @admins = <OLD>;
			close (OLD);

			# Go through each line.
			my $new_list;
			foreach $line (@admins) {
				chomp $line;
				$line =~ s/ //g;
				$line = lc($line);
				$args =~ s/ //g;
				$args = lc($args);

				if ($line eq $args) {
					$line = "";
				}
				else {
					$line = "$line\n";
				}

				# Save the new list.
				$new_list .= "$line";
			}

			# Save the list.
			open (NEW, ">./data/authority/admin.txt");
			print NEW $new_list;
			close (NEW);

			$reply = "I have removed Admin priviledges for $args.";
		}
		else {
			# Not a valid !mod command.
			$reply = ("Invalid command. Valid commands are:\n\n"
				. "!admin mod [username]\n"
				. "!admin demod [username]\n"
				. "!admin admin [username]\n"
				. "!admin deadmin [username]");
		}
	}
	else {
		# If they're not a privileged user...
		$reply = "Sorry, but this command can only be used by Admins!";
	}

	# Return the reply.
	return $reply;
}
1;