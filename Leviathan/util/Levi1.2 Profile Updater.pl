#!/usr/bin/perl -w

print "AiChaos Leviathan Utility\n"
	. "-------------------------\n"
	. "This utility will update pre-Leviathan 1.2 user profiles\n"
	. "to be compatible with Leviathan 1.2 and later.\n\n"
	. "Details:\n"
	. "    -Transforms each user profile to the new standard (keeping "
	. "data intact)\n\n"
	. "Continue? <y|n> ==> ";
my $proceed = <STDIN>;
chomp $proceed;

if ($proceed =~ /^y$/i) {
	# Hashref for users.
	my $users = {};

	# Continue.
	print "\n\n"
		. "Opening userdir...\n";
	opendir (USRS, "../clients");
	print "Converting user profiles:\n";
	foreach my $file (sort(grep(!/^\./, readdir(USRS)))) {
		next unless $file =~ /\.txt$/i;
		open (FILE, "../clients/$file");
		my @data = <FILE>;
		close (FILE);
		chomp @data;

		foreach my $line (@data) {
			next if $line =~ /^\//;
			my ($what,$is) = split(/=/, $line, 2);
			$what = lc($what);
			$what =~ s/ //g;

			$users->{$file}->{$what} = $is;
		}

		print "\t$file... ";
		my @vars = (
			'stars',
			'blocked',
			'blocks',
			'expire',
			'exmins',
			'',
			'// Custom Fields //',
			'name',
			'age',
			'sex',
			'location',
			'time',
			'personality',
			'color',
			'book',
			'band',
			'job',
			'spouse',
			'sexuality',
		);
		open (NEW, ">../clients/$file");
		print NEW "points=$users->{$file}->{points}";
		foreach my $var (@vars) {
			if (length $var > 0 && $var ne '// Custom Fields //') {
				print NEW "\n$var=$users->{$file}->{$var}";
			}
			else {
				print NEW "\n$var";
			}
		}
		close (NEW);

		print "Done!\n";
	}
	closedir (USRS);

	print "Conversion complete.\n";
	sleep(100);
}