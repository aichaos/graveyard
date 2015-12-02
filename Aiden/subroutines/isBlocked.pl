# isBlocked.pl - checks if a user is blocked

sub isBlocked {
	my $client = shift;

	# Master can not be blocked.
	return (0,undef) if &isMaster($client);

	# If they're temporarily blocked...
	if (exists $aiden->{clients}->{$client}->{blocked} && $aiden->{clients}->{$client}->{blocked} == 1) {
		my $expires = $aiden->{clients}->{$client}->{expires};
		my $len = $expires - time();
		my $mins = $len / 60;
		$mins =~ s/(.*?)\.(.).*/$1\.$2/g;
		return (1,"Temporary Block: $mins minutes remaining.");
	}

	# If they're ourself.
	my ($l,$n) = split(/\-/, $client, 2);
	if (defined $n && exists $aiden->{bots}->{$n}) {
		return (1,"Looping Connection.");
	}

	# Check the blacklist.
	open (BL, "./data/blacklist.txt");
	my @data = <BL>;
	close (BL);
	chomp @data;
	foreach my $line (@data) {
		my ($name,$reason) = split(/::/, $line, 2);

		# Matching.
		if ($name =~ /\*/) {
			my ($lis,$nick) = split(/=/, $name, 2);
			if (defined $l && defined $lis && $lis eq $l) {
				$name =~ s/\*/\(\.\*\?\)/g;
				$name =~ s/\@/\\@/g;
				$name =~ s/\./\\./g;

				if ($n =~ /$nick/i) {
					return (1,"Permanent Ban (BlackList): $reason");
				}
			}
		}
		else {
			if ($client eq $name) {
				return (1,"Permanent Ban (BlackList): $reason");
			}
		}
	}

	return (0,undef);
}
1;