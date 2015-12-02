#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !madlib
#    .::   ::.     Description // Mad Libs
# ..:;;. ' .;;:..        Usage // !madlib
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub madlib {
	my ($self,$client,$msg,$listener) = @_;

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

	# If the callback exists...
	if ($chaos->{_users}->{$client}->{callback} eq "madlib") {
		DoMadLib:

		# Filtering?
		if (exists $chaos->{_users}->{$client}->{_madlib}->{filter}) {
			my $filter = $chaos->{_users}->{$client}->{_madlib}->{filter};
			return "I needed a $filter: reply with one now!" unless length $msg > 0;

			$chaos->{_users}->{$client}->{_madlib}->{lib} =~ s/<$filter>/$msg/i;

			delete $chaos->{_users}->{$client}->{_madlib}->{filter};
		}

		# If there is still an item...
		if ($chaos->{_users}->{$client}->{_madlib}->{lib} =~ /<(.*?)>/i) {
			# Ask it.
			my $item = $1;
			my @ask = ("Give me a ", "I need a ");

			# Prepare the filter...
			$chaos->{_users}->{$client}->{_madlib}->{filter} = $item;
			return ($ask [ int(rand(scalar(@ask))) ]) . $item . ".";
		}
		else {
			# Return the finished MadLib.
			my $madlib = $chaos->{_users}->{$client}->{_madlib}->{lib};

			delete $chaos->{_users}->{$client}->{callback};
			delete $chaos->{_users}->{$client}->{_madlib};

			return $madlib;
		}
	}
	else {
		# Start the mad lib.
		my $choice = $libs [ int(rand(scalar(@libs))) ];

		# If they cut the last game short...
		delete $chaos->{_users}->{$client}->{_madlib} if exists $chaos->{_users}->{$client}->{_madlib};

		# Set the hashes.
		$chaos->{_users}->{$client}->{callback} = 'madlib';
		$chaos->{_users}->{$client}->{_madlib}->{lib} = $choice;

		# Continue the madlib.
		goto DoMadLib;
	}
}

{
	Category => 'Fun & Games',
	Description => 'Mad Libs',
	Usage => '!madlib',
	Listener => 'All',
};