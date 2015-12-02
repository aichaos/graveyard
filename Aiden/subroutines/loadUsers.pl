# loadUsers.pl - load all userdata.

sub loadUsers {
	# Open users folder.
	opendir (DIR, "./clients");
	foreach my $file (sort(grep(!/^\./, readdir(DIR)))) {
		next unless $file =~ /\.usr$/i;
		$file =~ s/\.usr$//ig;

		&userGet ($file);
	}
	closedir (DIR);
}
1;