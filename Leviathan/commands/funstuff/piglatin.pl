#      .   .               <Leviathan>
#     .:...::     Command Name // !piglatin
#    .::   ::.     Description // Pig Latin Translator.
# ..:;;. ' .;;:..        Usage // !piglatin <text>
#    .  '''  .     Permissions // Public.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub piglatin {
	my ($self,$client,$msg) = @_;

	# Requires a message.
	if (length $msg > 0) {
		# Format the message.
		$msg = lc($msg);
		$msg =~ s/[^A-Za-z0-9 ]//ig;
		my @words = split(/\s+/, $msg);

		my @out;

		# Go through each word.
		my $count = 0;
		foreach my $item (@words) {
			my @chars = split(//, $item);

			# Check the number of consonants at the beginning.
			$count = &piglatin_consonants ($chars[0]) + &piglatin_consonants ($chars[1]);

			# If it's just one consonant...
			my ($first,$second);
			if (&piglatin_consonants($chars[0]) == 0) {
				# Started with a vowel.
				$chars [ scalar(@chars) ] = "way";
			}
			elsif ($count == 1) {
				# Put it at the end.
				$first = shift(@chars);
				$chars [ scalar(@chars) ] = $first . "ay";
			}
			elsif ($count == 2) {
				# Put both at the end.
				$first = shift(@chars);
				$second = shift(@chars);
				$chars [ scalar(@chars) ] = $first . $second . "ay";
			}
			else {
				return "Unknown error.";
			}

			# Rejoin the new word.
			my $new_text = CORE::join ("", @chars);
			push (@out, $new_text);
		}

		# Return the result.
		my $result = CORE::join (" ", @out);
		return $result;
	}
	else {
		return "Give me a message to convert:\n\n"
			. "!piglatin The quick brown fox jumps over the lazy dog.";
	}
}
sub piglatin_consonants {
	my $char = shift;
	$char = lc($char);

	# List of consonants.
	my @con = qw(b c d f g h j k l m n p q r s t v w x y z);
	foreach my $item (@con) {
		if ($char eq $item) {
			return 1;
		}
	}

	return 0;
}
{
	Category    => 'Fun Stuff',
	Description => 'Piglatin Translator.',
	Usage       => '!piglatin <text>',
	Listener    => 'All',
};