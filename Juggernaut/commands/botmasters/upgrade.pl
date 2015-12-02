#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !upgrade
#    .::   ::.     Description // Upgrade bot's source files from Internet source.
# ..:;;. ' .;;:..        Usage // !upgrade <local file>-><remote url>
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub upgrade {
	my ($self,$client,$msg,$listener) = @_;

	# This command is Master Only.
	if (isMaster($client,$listener)) {
		# Get variables from the message.
		my ($file,$src) = split(/\-\>/, $msg, 2);

		$file =~ s/\s//g;
		$src =~ s/^\s//g;

		# If both variables exist...
		if (length $file > 0 && length $src > 0) {
			# Make sure the file they're replacing is okay.
			if (-e $file == 1) {
				# Don't allow editing of files in the backup folder.
				if ($file =~ /^\.\/backup/i || $file =~ /^backup/i) {
					return "You cannot update files in the backup folder.";
				}

				# Make sure the source is valid.
				if ($src =~ /^http/i || $src =~ /^ftp/i) {
					# Get the source.
					my $data = get $src or return "The source could not be found!";
					my @info = split(/\n/, $data);

					# Read the source.
					chomp @info;
					my $new;
					foreach my $line (@info) {
						$new .= "$line\n";
					}

					# Copy the old file into the backup directory (just in case).
					my @pairs = split(/\//, $file);
					my $last = $pairs [ scalar(@pairs) - 1 ];
					print "Debug // Last Pair: $last\n";
					open (SRC, "$file");
					my @back = <SRC>;
					close (SRC);
					chomp @back;
					open (BAK, ">./backup/$last");
					foreach $line (@back) {
						print BAK "$line\n";
					}
					close (BAK);

					# Rewrite the new data.
					open (NEW, ">$file");
					print NEW $new;
					close (NEW);

					# Re-require the new file.
					do "$file" or return "That file had fatal errors, you might be able to "
						. "back up the file using !backup $last, or if it was a critical "
						. "file you may not be able to do anything about it. :(";

					# Return the reply.
					return "I have updated that file. If you want to revert to the old copy, "
						. "type !backup $last";
				}
				else {
					return "That is an invalid source URL. A source URL must be on a "
						. "HTTP or FTP server.";
				}
			}
			else {
				return "That file was nowhere to be found.";
			}
		}
		else {
			return "Command usage:\n\n"
				. "!upgrade [path to file]-<gt>[web location to new file]";
		}
	}
	else {
		return "This command is Master Only.";
	}
}

{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Upgrade File from Online Source',
	Usage => '!update <local path>-><web location>',
	Listener => 'All',
};