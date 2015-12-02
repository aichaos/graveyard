# COMMAND NAME:
#	UNWARN
# DESCRIPTION:
#	Removes a user from the warners list.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub unwarn {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we have somebody TO unwarn.
	if ($msg) {
		# Add them to the blocked list.
		open (OLD, "./data/warners.txt");
		my @old_list = <OLD>;
		close (OLD);

		# Recreate the list.
		chomp @old_list;
		my $final;
		foreach $line (@old_list) {
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

		# Save the new file.
		open (NEW, ">./data/warners.txt");
		print NEW $final;
		close (NEW);

		$reply = "I have removed $msg from the warners list.";
	}
	else {
		$reply = "Improper usage. Correct usage is: !unwarn [username]";
	}

	return $reply;
}
1;