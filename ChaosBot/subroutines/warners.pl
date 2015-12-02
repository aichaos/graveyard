# Subroutine: warners
# Checks if the AIM user is on the warners list.
# If so, warn and block him.

sub warners {
	# Get the person in question from the shift.
	my ($self,$client) = @_;

	# Initially, they're not a warner.
	my $warner = 0;

	# Get our screenname.
	my $screenname = $self->screenname();

	# Open the warners list if it exists.
	if (-e "./data/warners.txt" == 1) {
		open (LIST, "./data/warners.txt");
		my @list = <LIST>;
		close (LIST);

		# Go through the list.
		foreach $item (@list) {
			chomp $item;
			$item = lc($item);
			$item =~ s/ //g;

			# If they compare, they're a warner.
			if ($item eq $client) {
				$warner = 1;
			}
		}
	}

	# If they're a warner, warn and block them.
	if ($warner == 1) {
		$self->evil ($client, 0);
		$self->add_deny ($client);
		print "ChaosAIM: I have attacked the idiot warner $client.\n\n";
	}

	# Return the binary warner value.
	return $warner;
}
1;