#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !gb
#    .::   ::.     Description // Get a random Guestbook entry.
# ..:;;. ' .;;:..        Usage // !gb
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub gb {
	my ($self,$client,$msg,$listener) = @_;

	# See if this is a subcommand.
	if ($msg) {
		if ($msg eq "clear") {
			# Make sure they're the Master.
			if (isMaster($client,$listener)) {
				# Delete the book.
				unlink ("./data/gb.txt");
				$reply = "I have deleted the guestbook.";
			}
			else {
				$reply = "Only the Master can delete the book.";
			}
		}
		else {
			$reply = "The guestbook command does not require any arguments.";
		}
	}
	else {
		# Make sure the guestbook exists.
		if (-e "./data/gb.txt" == 1) {
			# Open it.
			open (GB, "./data/gb.txt");
			my @gb = <GB>;
			close (GB);

			chomp @gb;

			my $found = 0;
			my ($gb,$entry);
			while ($found == 0) {
				$entry = $gb [ int(rand(scalar(@gb))) ];
				if ($reply ne "") {
					$found = 1;
				}
			}

			my ($from,$date,$value) = split(/\]\[/, $entry, 3);

			$reply = "Random Guestbook Entry:\n"
				. "From: $from\n"
				. "Date: $date\n"
				. "$value";
		}
		else {
			$reply = "There are no messages in the guestbook.";
		}
	}

	return $reply;
}

{
	Category => 'General',
	Description => 'Random Guestbook Entry',
	Usage => '!gb',
	Listener => 'All',
};