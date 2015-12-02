# COMMAND NAME:
#	UNBLOCK
# DESCRIPTION:
#	Removes a user from the blocked list.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub unblock {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we have somebody TO unblock.
	if ($msg) {
		# Add them to the blocked list.
		open (OLD, "./data/blocked.txt");
		my @old_block = <OLD>;
		close (OLD);

		# Recreate the list.
		chomp @old_block;
		my $final;
		foreach $line (@old_block) {
			if ($line) {
				$line = lc($line);
				$line =~ s/ //g;
				$msg = lc($msg);
				$msg =~ s/ //g;

				if ($msg ne $line) {
					$final .= "$line\n";
				}
			}
		}

		# Save the new list.
		open (NEW, ">./data/blocked.txt");
		print NEW $final;
		close (NEW);

		$reply = "I have removed $msg from the blocked list.";
	}
	else {
		$reply = "Improper usage. Correct usage is: !unblock [username]";
	}

	return $reply;
}
1;