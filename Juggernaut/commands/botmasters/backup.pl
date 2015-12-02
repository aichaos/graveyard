#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !backup
#    .::   ::.     Description // Backup a source from recently upgraded file.
# ..:;;. ' .;;:..        Usage // !backup <filename>
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub backup {
	my ($self,$client,$msg,$listener) = @_;

	# This command is Master Only.
	if (isMaster($client,$listener)) {
		# Get variables from the message.
		my ($backup,$location) = split(/\-\>/, $msg, 2);

		$file =~ s/\s//g;
		$src =~ s/^\s//g;

		# If both variables exist...
		if (length $backup > 0 && length $location > 0) {
			# Make sure the target location exists.
			if (-e "$location" == 0) {
				return "The target location is invalid or doesnt exist. You "
					. "may only backup existing files.";
			}

			# Make sure the backup file exists.
			if (-e "./backup/$backup" == 1) {
				# Copy the backup file into the backup directory (just in case).
				open (SRC, "./backup/$backup");
				my @back = <SRC>;
				close (SRC);
				chomp @back;
				open (BAK, ">$location");
				foreach my $line (@back) {
					print BAK "$line\n";
				}
				close (BAK);

				# Re-require the new file.
				do "$location" or return "That backup file had fatal errors, you might be able to "
					. "back up the file using !backup $last, or if it was a critical "
					. "file you may not be able to do anything about it. :(";

				# Return the reply.
				return "I have restored the last saved copy from the backup folder. :)";
			}
			else {
				return "That file was nowhere to be found.";
			}
		}
		else {
			return "Command usage:\n\n"
				. "!upgrade [name of backup file]-<gt>[path for file to be copied to]";
		}
	}
	else {
		return "This command is Master Only.";
	}
}

{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Back up a recently upgraded file',
	Usage => '!backup <filename>-><location to send>',
	Listener => 'All',
};