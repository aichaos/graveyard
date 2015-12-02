# COMMAND NAME:
#	MOD
# DESCRIPTION:
#	Moderator controls (block/warners/etc)
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub mod {
	# Get strings from the shift.
	my ($client,$msg,$self) = @_;

	# Cut off the command.
	$msg =~ s/\!mod //ig;

	# First, make sure they're a Mod (or Admin)
	if (isMod($client) || isAdmin($client)) {
		# Moderator Commands:
		# !mod block <username>    => Add to blocked list
		# !mod unblock <username>  => Remove from block list
		# !mod warn <username>     => Add to warners list
		# !mod unwarn <username>   => Remove from warners list
		# !mod report <user> <msg> => Leave the botmaster a message

		# Get the command and arguments.
		my ($command,@args) = split(/ /, $msg);
		my $args = join(/ /, @args);

		# Go through each command.
		if ($command eq "block") {
			# Block a user.
			open (BLOCK, ">>./data/blocked.txt");
			print BLOCK "$args\n";
			close (BLOCK);

			$reply = "I have added $args to the blocked list.";
		}
		elsif ($command eq "unblock") {
			# Unblock a user.
			open (OLD, "data/blocked.txt");
			my @blocked = <OLD>;
			close (OLD);

			# Go through each line.
			my $new_list;
			foreach $line (@blocked) {
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
			open (NEW, ">./data/blocked.txt");
			print NEW $new_list;
			close (NEW);

			$reply = "I have unblocked $args.";
		}
		elsif ($command eq "warn") {
			# Add a warner to the list.
			open (LIST, ">>./data/warners.txt");
			print LIST "\n$args";
			close (LIST);

			$reply = "I have added $args to the warners list.";
		}
		elsif ($command eq "unwarn") {
			# Remove a warner from the list.
			open (OLD, "data/warners.txt");
			my @blocked = <OLD>;
			close (OLD);

			# Go through each line.
			my $new_list;
			foreach $line (@blocked) {
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
			open (NEW, ">./data/warners.txt");
			print NEW $new_list;
			close (NEW);

			$reply = "I have removed $args from the warners list.";
		}
		elsif ($command eq "report") {
			# Reporting a user to the botmaster.
			my ($user,@report) = split(/ /, $args);
			my $report = join(/ /, @report);

			# Save the report.
			open (REPORT, ">>data/report.txt");
			print REPORT ("MOD REPORT\n"
				. "FROM: $client\n"
				. "ABOUT: $user\n"
				. "MESSAGE: $report\n\n");
			close (REPORT);

			$reply = "I have left the message.";
		}
		else {
			# Not a valid !mod command.
			$reply = ("Invalid command. Valid commands are:\n\n"
				. "!mod block [username]\n"
				. "!mod unblock [username]\n"
				. "!mod warn [username]\n"
				. "!mod unwarn [username]\n"
				. "!mod report [username] [msg]");
		}
	}
	else {
		# If they're not a privileged user...
		$reply = "Sorry, but this command can only be used by Moderators!";
	}

	# Return the reply.
	return $reply;
}
1;