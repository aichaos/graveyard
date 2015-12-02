# Subroutine: commands
# Goes through the list of commands.

sub commands {
	# Get needed variables from the shift.
	my ($client,$msg,$self) = @_;

	# Get the local time.
	my $time = localtime();

	# Initially, they're not using a command.
	$reply = "";
	my $is_a_command = 0;

	# Open the commands folder and get to work.
	opendir (CMD, "./commands");
	foreach $file (sort(grep(!/^\./, readdir(CMD)))) {
		$file =~ s/\.(.*)//g;
		if ($is_a_command == 0) {
			if ($msg =~ /^\!$file/i) {
				$is_a_command = 1;
				$reply = &{$file} ($client,$msg,$self);
			}
		}
	}
	closedir (CMD);

	# If there isn't a reply yet, it's not a command.
	if ($reply eq "") {
		$reply = "notcommand";
	}

	# If this isn't a command but it could be...
	if ($is_a_command == 0) {
		if ($msg =~ /^\!/) {
			$is_a_command = 1;
			$reply = "notcommand";
		}
	}

	# Return the command and the reply.
	return ($is_a_command,$reply);
}
1;