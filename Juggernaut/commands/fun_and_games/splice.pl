#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !splice
#    .::   ::.     Description // Sentence Splicer
# ..:;;. ' .;;:..        Usage // !splice <sentence>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub splice {
	my ($self,$client,$msg,$listener) = @_;

	# Credits:
	#     Kirsle- Programmed the command.
	#     Daz- Inspiration for the command.

	# If there's a string . . .
	if (length $msg > 0) {
		$msg = lc($msg);

		# Get the array of words.
		my @words = split(/ /, $msg);

		# Create an array of first letters.
		my @first;

		# Go through each word.
		foreach my $word (@words) {
			# Get all the characters.
			my @chars = split(//, $word);

			# Shift and add the first letter to @first.
			push (@first, shift(@chars));
		}

		# Shuffle the order of first letters.
		my $i;
		for ($i = @first; --$i; ) {
			my $j = int rand ($i+1);
			next if $i == $j;
			@first[$i,$j] = @first[$j,$i];
		}

		# Create an array for the final product.
		my @final;

		# Go through each word (again) and insert a random first
		# character.
		my $loops;
		foreach $word (@words) {
			# Get the characters.
			@chars = split(//, $word);

			$loops = 0;

			# Shift off the first letter of THIS word, it's not important.
			my $alpha = shift (@chars);

			shuffleNoRepeat:
			if ($first[0] eq $alpha && $loops < 5) {
				# Reshuffle and continue.
				for ($i = @first; --$i; ) {
					my $j = int rand ($i+1);
					next if $i == $j;
					@first[$i,$j] = @first[$j,$i];
				}

				# If they still match...
				if ($first[0] eq $alpha) {
					$loops++;
					goto shuffleNoRepeat;
				}
			}

			# Unshift a random first letter from @first.
			unshift (@chars, shift(@first));

			# Add this to the final sentence.
			push (@final, join ("", @chars));
		}

		# Return the message.
		my $return_out = join (" ", @final);
		return $return_out;
	}
	else {
		return "Give me a sentence to splice up:\n\n"
			. "!splice All your base are belong to us.";
	}
}

{
	Category => 'Fun & Games',
	Description => 'Sentence Splicer',
	Usage => '!splice <sentence>',
	Listener => 'All',
};