#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !scramble
#    .::   ::.     Description // A word scramble game.
# ..:;;. ' .;;:..        Usage // !scramble
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub scramble {
	my ($self,$client,$msg,$listener) = @_;

	# (C) 2004 Cerone Kirsle.

	# If they're already playing.
	if ($chaos->{_users}->{$client}->{callback} eq "scramble") {
		# See if they haven't run out of time.
		if (time() - $chaos->{_users}->{$client}->{_scramble}->{start} <= $chaos->{_users}->{$client}->{_scramble}->{limit}) {
			# Check if they got the word right.
			$msg = lc($msg);
			$msg =~ s/ //g;

			my $elapse = time() - $chaos->{_users}->{$client}->{_scramble}->{start};

			if ($msg eq $chaos->{_users}->{$client}->{_scramble}->{word}) {
				# They got it!
				delete $chaos->{_users}->{$client}->{callback};
				delete $chaos->{_users}->{$client}->{_scramble};

				return "YES! You got the word ($msg)!\n\n"
					. "Your elapsed time was $elapse seconds. Good job!";
			}
			else {
				# Get the time left.
				my $left = time() - $chaos->{_users}->{$client}->{_scramble}->{timer};
				$left =~ s/\-//ig;
				return "Sorry :-( That's not what the word was. You have $left seconds left, keep trying! :-)";
			}
		}
		else {
			# They ran out of time.
			my $word = $chaos->{_users}->{$client}->{_scramble}->{word};
			delete $chaos->{_users}->{$client}->{callback};
			delete $chaos->{_users}->{$client}->{_scramble};

			return "*** TIME'S UP! ***\n\n"
				. "You have run out of time. Your word was $word. Play again, type !scramble! :-)";
		}
	}
	else {
		# Get a word.
		my @words = (
			"acrimonious",
			"allegiance",
			"ameliorate",
			"annihilate",
			"antiseptic",
			"articulate",
			"authoritative",
			"benfactor",
			"boisterous",
			"breakthrough",
			"carcinogenic",
			"censorious",
			"chivalrous",
			"collarbone",
			"commendable",
			"compendium",
			"comprehensive",
			"conclusive",
			"conscientious",
			"considerate",
			"deferential",
			"denouement",
			"determinate",
			"diffidence",
			"disruption",
			"earthenware",
			"elliptical",
			"entanglement",
			"escutcheon",
			"extinguish",
			"extradition",
			"fastidious",
			"flamboyant",
			"forethought",
			"forthright",
			"gregarious",
			"handmaiden",
			"honeysuckle",
			"hypocritical",
			"illistrious",
			"infallible",
			"lumberjack",
			"mischievous",
			"mollycoddle",
			"nimbleness",
			"nonplussed",
			"obliterate",
			"obsequious",
			"obstreperous",
			"opalescent",
			"ostensible",
			"pandemonium",
			"paraphernalia",
			"pawnbroker",
			"pedestrian",
			"peremptory",
			"perfunctory",
			"pernicious",
			"perpetrate",
			"personable",
			"pickpocket",
			"poltergeist",
			"precipitous",
			"predicament",
			"preposterous",
			"presumtuous",
			"prevaricate",
			"prompensity",
			"provisional",
			"pugnacious",
			"ramshackle",
			"rattlesnake",
			"reciprocate",
			"recrimination",
			"redoubtable",
			"relinquish",
			"remonstrate",
			"repository",
			"reprehensible",
			"resolution",
			"resplendent",
			"restitution",
			"retaliation",
			"retribution",
			"saccharine",
			"salubrious",
			"skulduggery",
			"skyscraper",
			"soothsayer",
			"tearjerker",
			"transcribe",
			"turpentine",
			"unassuming",
			"underscore",
			"undertaker",
			"underwrite",
			"unobtrusive",
			"vernacular",
			"waterfront",
			"watertight",
		);

		# Get a random word.
		my $choice = $words [ int(rand(scalar(@words))) ];
		my $len = (scalar(@words)) - 1;

		# Randomize the words.
		my @chosen;
		my @string = split(//, $choice);
		my $i;
		for ($i = @string; --$i; ) {
			my $j = int rand ($i+1);
			next if $i == $j;
			@string[$i,$j] = @string[$j,$i];
		}
		my $scramble = join (" ", @string);
		$scramble =~ s/\s+//ig;

		print "Debug // Chosen Word: $choice\n\n";

		# Save variables.
		$chaos->{_users}->{$client}->{callback} = 'scramble';
		$chaos->{_users}->{$client}->{_scramble}->{word} = $choice;
		$chaos->{_users}->{$client}->{_scramble}->{scramble} = $scramble;
		$chaos->{_users}->{$client}->{_scramble}->{timer} = time() + ((scalar(@words)) * 5);
		$chaos->{_users}->{$client}->{_scramble}->{start} = time();
		$chaos->{_users}->{$client}->{_scramble}->{limit} = (scalar (@words)) * 5;

		return ":: Word Scramble ::\n\n"
			. "We're playing Word Scramble. I am randomly chosen a word to scramble, "
			. "and you have $chaos->{_users}->{$client}->{_scramble}->{limit} seconds "
			. "to decode it. The scrambled word is:\n\n"
			. "<b>$chaos->{_users}->{$client}->{_scramble}->{scramble}</b>";
	}
}

{
	Category => 'Fun & Games',
	Description => 'Word Scramble',
	Usage => '!scramble',
	Listener => 'All',
};