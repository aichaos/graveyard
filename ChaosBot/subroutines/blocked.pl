# Subroutine: blocked
# Checks if the user is blocked from talking to the bot.

sub blocked {
	# Get the person in question from the shift.
	my $client = shift;

	# Initially, they're not blocked.
	my $blocked = 0;

	# Open the blocked list if it exists.
	if (-e "./data/blocked.txt" == 1) {
		open (LIST, "./data/blocked.txt");
		my @list = <LIST>;
		close (LIST);

		# Go through the list.
		foreach $item (@list) {
			chomp $item;
			$item = lc($item);
			$item =~ s/ //g;

			# If they compare, they're blocked.
			if ($item eq $client) {
				$blocked = 1;
				print "CKS // Ignoring message from $client (blocked)\n\n";
			}
		}
	}

	# Return the binary value.
	return $blocked;
}
1;