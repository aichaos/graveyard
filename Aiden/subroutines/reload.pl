# reload.pl - Reload the bot.

sub reload {
	my ($client) = @_;

	# 1. Reload config files.
	$aiden->{root} = do "./config/Connections.cfg";
	do "./config/Settings.cfg";
	do "./config/Substitutions.cfg";

	# 2. Reload brains.
	&loadBrains();

	# 3. Reload subroutines.
	opendir (DIR, "./subroutines");
	foreach my $file (sort(grep(!/^\./, readdir(DIR)))) {
		next unless $file =~ /\.pl$/i;
		do "./subroutines/$file";
	}
	closedir (DIR);

	# 4. Reload commands.
	opendir (DIR, "./commands");
	foreach my $file (sort(grep(!/^\./, readdir(DIR)))) {
		next unless $file =~ /\.pl$/i;
		do "./commands/$file";
	}
	closedir (DIR);

	# 5. Reload handlers.
	opendir (DIR, "./handlers");
	foreach my $file (sort(grep(!/^\./, readdir(DIR)))) {
		next unless $file =~ /\.pl$/i;
		do "./handlers/$file";
	}
	closedir (DIR);

	return "Bot reloaded successfully!";
}
1;