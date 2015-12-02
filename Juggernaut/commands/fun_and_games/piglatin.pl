#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !piglatin
#    .::   ::.     Description // Convert a message to pig latin.
# ..:;;. ' .;;:..        Usage // !piglatin <message>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub piglatin {
	my ($self,$client,$msg,$listener) = @_;

	# If there's a message to convert...
	if (length $msg > 0) {
		# Format the message.
		$msg = lc($msg);
		$msg =~ s/[^A-Za-z0-9 ]//ig;
		my @words = split(/\s+/, $msg);

		my @out;

		# Go through each word.
		my $count;
		foreach my $item (@words) {
			my @chars = split("", $item);

			# Check the number of consonants at the beginning.
			$count = piglatin_consonants ($chars[0]) + piglatin_consonants ($chars[1]);
			print "Count for $item: $count\n";

			# If it's just one consonant...
			my ($first,$second);
			if (piglatin_consonants ($chars[0]) == 0) {
				# Started with a vowel.
				#$first = shift (@chars);
				$chars [ scalar(@chars) ] = "way";
			}
			elsif ($count == 1) {
				# Put it at the end.
				$first = shift (@chars);
				$chars[ scalar(@chars) ] = $first . "ay";
			}
			elsif ($count == 2) {
				# Put both at the end.
				$first = shift (@chars);
				$second = shift (@chars);
				$chars[ scalar(@chars) ] = $first . $second . "ay";
			}
			else {
				&panic ("Weird error at piglatin.pl", 0);
				return "Unknown error.";
			}

			# Rejoin this word.
			my $new_text = join (" ", @chars);
			$new_text =~ s/\s+//g;
			push (@out, $new_text);
		}

		# Return the result.
		my $result = join (" ",@out);
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

	print "Consonants: \$char = $char\n";

	# List of consonants.
	my @con = (
		'b','c','d',
		'f','g','h',
		'j','k','l','m','n',
		'p','q','r','s','t',
		'v','w','x','y','z',
	);
	foreach my $item (@con) {
		if ($char eq $item) {
			print "Consonants: Matched $char with $item\n";
			return 1;
		}
	}

	# Return void.
	return 0;
}

{
	Category => 'Fun & Games',
	Description => 'Pig Latin Translator',
	Usage => '!piglatin <string>',
	Listener => 'All',
};