# AIM Handler: evil
# Handles warnings recieved by the bot.

sub aim_evil {
	# Get server arguments from the shift.
	my ($aim,$lvl,$from) = @_;

	my $time = localtime();

	my $screenname = $aim->screenname();

	print "$time\n";
	print "ChaosAIM: $screenname has been warned to $lvl\%.. ";

	if (not defined $from) {
		print "this was done anonymously!\n\n";
		$from = "anon";
	}
	else {
		print "$from did this!\n\n";
	}

	# If we know who did it...
	if ($from ne "anon") {
		# Let's add the bastard to the warners list.
		# If the list doesn't exist...
		if (-e "./data/warners.txt" != 1) {
			# Create it.
			open (WARNERS, ">./data/warners.txt");
			print WARNERS "$from";
			close (WARNERS);
		}
		else {
			# Add to the list.
			open (WARNERS, ">>./data/warners.txt");
			print WARNERS "\n$from";
			close (WARNERS);
		}
	}

	if ($lvl > 10) {
		# Put up an away message.
		$aim->set_away ("<body bgcolor=\"black\"><font face=\"Verdana,Arial\" "
			. "size=\"2\" color=\"red\">I am away due to warners.</font></body>");
		$is_away = 1;
	}
}
1;