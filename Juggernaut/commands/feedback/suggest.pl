#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !suggest
#    .::   ::.     Description // Submit suggestions to the master.
# ..:;;. ' .;;:..        Usage // !suggest <suggestion>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub suggest {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure they have a suggestion.
	if ($msg) {
		if ($msg eq "read") {
			# Reading suggestions. Make sure they are the Master.
			if (isMaster($client,$listener)) {
				if (-e "./data/suggestions.txt" == 1) {
					open (READ, "./data/suggestions.txt");
					my @contents = <READ>;
					close (READ);
					chomp @contents;

					$reply = "Here are the current suggestions\n\n";

					my $count = 1;
					foreach $line (@contents) {
						$reply .= "<b>$count</b>) $line\n\n";
						$count++;
					}
				}
				else {
					$reply = "There are currently no suggestions.";
				}
			}
			else {
				$reply = "Only the botmaster can read the suggestions.";
			}
		}
		elsif ($msg eq "clear") {
			# Clearing suggestions. Make sure they are the Master.
			if (isMaster($client,$listener)) {
				unlink ("./data/suggestions.txt");

				$reply = "I have cleared the suggestions.";
			}
		}
		else {
			open (SUGGEST, ">>./data/suggestions.txt");
			print SUGGEST "$msg\n";
			close (SUGGEST);

			$reply = "Thank you for your suggestion!";
		}
	}
	else {
		$reply = "To leave a suggestion type:\n\n"
			. "!suggest [suggestion]";
	}

	return $reply;
}

{
	Category => 'Feedback',
	Description => 'Make a Suggestion',
	Usage => '!suggest <suggestion>',
	Listener => 'All',
};