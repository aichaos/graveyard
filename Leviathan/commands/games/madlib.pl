#      .   .               <Leviathan>
#     .:...::     Command Name // !madlib
#    .::   ::.     Description // Mad Libs!
# ..:;;. ' .;;:..        Usage // !madlib
#    .  '''  .     Permissions // Public.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub madlib {
	my ($self,$client,$msg) = @_;

	# Array of libs.
	my @libs = (
		"These are the release <plural noun> for <proper noun> version <number>.<another number>."
			. "<yet another number>. "
			. "<verb> them <adjective>, as they tell you what this is all about, tell how to "
			. "<verb> the <noun>, and what to do if something goes wrong.",
		"To be, or not to <verb> -- that is the <noun>;\n"
			. "Whether 'tis nobler in the <noun> to suffer\n"
			. "The slings and <plural noun> of <adjective> fortune,\n"
			. "Or to take <plural noun> against a sea of <plural noun>,\n"
			. "And by <verb ending in -ing> end them. To die, -- to <verb>, --\n"
			. "No more; and by a <verb> to say we end\n"
			. "The <noun> and the <large number> natural shocks\n"
			. "That flesh is <profession> to -- 'tis a <noun>\n"
			. "<adverb> to be wish'd. To die, -- to <verb>, --\n"
			. "To <verb>! Perchance to <verb>! Ay, there's the <noun>;\n"
			. "For in that <verb> of death what <plural noun> may come\n"
			. "When we have <past-tense verb> off this <adjective> coil,\n"
			. "Must give us <noun>...",
		"Einstein believed that <person's name ending with -'s> theory should, like "
			. "all other laws of <noun> obey the principle of <abstract noun>. In "
			. "other <plural noun>, <persons name with -'s> <noun> should be "
			. "<adjective> even within any <verb ending in -ing> reference <noun>. "
			. "Since speed c is built into the laws of <noun>, Einstein <past-tense verb> "
			. "that \"every observer ought to <verb> every light <noun> to move at "
			. "speed c\", regardless of the observer's <noun>. No matter how fast you "
			. "<verb>, a light <noun> always passes you at speed c, relative to you. "
			. "This is why the idea of <verb> up with a light <noun> seemed <adjective> "
			. "to Einstein. If every observer sees every light <noun> move at speed c, "
			. "then nobody can even bein to catch up with a light <noun>, much less catch "
			. "all the way up with one and <verb> it at rest.",
	);

	# If the callback doesn't exist...
	if ($chaos->{clients}->{$client}->{callback} ne "madlib") {
		# Start the mad lib.
		my $choice = $libs [ int(rand(scalar(@libs))) ];

		# If they cut the last game short...
		delete $chaos->{clients}->{$client}->{_madlib} if exists $chaos->{clients}->{$client}->{_madlib};

		# Set the hashes.
		$chaos->{clients}->{$client}->{callback} = 'madlib';
		$chaos->{clients}->{$client}->{_madlib}->{lib} = $choice;
	}

	# Filtering?
	if (exists $chaos->{clients}->{$client}->{_madlib}->{filter}) {
		my $filter = $chaos->{clients}->{$client}->{_madlib}->{filter};
		return "I needed a $filter: reply with one now!" unless length $msg > 0;

		$chaos->{clients}->{$client}->{_madlib}->{lib} =~ s/<$filter>/$msg/i;

		delete $chaos->{clients}->{$client}->{_madlib}->{filter};
	}

	# If there is still an item...
	if ($chaos->{clients}->{$client}->{_madlib}->{lib} =~ /<(.*?)>/i) {
		# Ask it.
		my $item = $1;
		my @ask = ("Give me a ", "I need a ");

		# Prepare the filter...
		$chaos->{clients}->{$client}->{_madlib}->{filter} = $item;
		return ($ask [ int(rand(scalar(@ask))) ]) . $item . ".";
	}
	else {
		# Return the finished MadLib.
		my $madlib = $chaos->{clients}->{$client}->{_madlib}->{lib};

		delete $chaos->{clients}->{$client}->{callback};
		delete $chaos->{clients}->{$client}->{_madlib};

		return $madlib;
	}
}
{
	Category    => 'Single-Player Games',
	Description => 'Mad Libs!',
	Usage       => '!madlib',
	Listener    => 'All',
};