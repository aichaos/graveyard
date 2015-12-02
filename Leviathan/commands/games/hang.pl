#      .   .               <Leviathan>
#     .:...::     Command Name // !hang
#    .::   ::.     Description // Hang Man.
# ..:;;. ' .;;:..        Usage // !hang
#    .  '''  .     Permissions // Public.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub hang {
	my ($self,$client,$msg) = @_;

	# We'll need a Courier New or monospaced font.
	my $font = "Courier New";
	my $reply;

	# Make sure that we're still playing the game.
	if ($chaos->{clients}->{$client}->{callback} eq "hang") {
		# Add one to their number of moves.
		$chaos->{clients}->{$client}->{_games}->{hang}->{moves}++;

		# See if they guessed the word correctly.
		$msg = lc($msg);
		if ($msg eq $chaos->{clients}->{$client}->{_games}->{hang}->{word}) {
			delete $chaos->{clients}->{$client}->{callback};

			# Give them bonus points for each vowel.
			my $total_earned = 5;

			$total_earned-- if $chaos->{clients}->{$client}->{_games}->{hang}->{guess} =~ /a/i;
			$total_earned-- if $chaos->{clients}->{$client}->{_games}->{hang}->{guess} =~ /e/i;
			$total_earned-- if $chaos->{clients}->{$client}->{_games}->{hang}->{guess} =~ /i/i;
			$total_earned-- if $chaos->{clients}->{$client}->{_games}->{hang}->{guess} =~ /o/i;
			$total_earned-- if $chaos->{clients}->{$client}->{_games}->{hang}->{guess} =~ /u/i;

			# If they've made it in 0 moves...
			if ($chaos->{clients}->{$client}->{_games}->{hang}->{moves} == 0) {
				$total_earned = 15;
				# Add the points to their record.
				&modPoints ($client,'+',$total_earned);

				return "Wow! You guessed it right off! You get 15 points for that! :-D\n\n"
					. "You've earned $total_earned points this round. "
					. "Type !hang to start a new game.";
			}
			# 1 moves = 10 points
			elsif ($chaos->{clients}->{$client}->{_games}->{hang}->{moves} == 1) {
				$total_earned += 10;
				# Add the points to their record.
				&modPoints ($client,'+',$total_earned);

				return "Wow, you guessed it after only 1 letter! You get 10 points! :-)\n\n"
					. "You've earned $total_earned points this round. "
					. "Type !hang to start a new game.";
			}
			# 2 moves = 8 points
			elsif ($chaos->{clients}->{$client}->{_games}->{hang}->{moves} == 2) {
				$total_earned += 8;
				# Add the points to their record.
				&modPoints ($client,'+',$total_earned);

				return "You guessed after only 2 moves. You get 8 points. :-)\n\n"
					. "You've earned $total_earned points this round. "
					. "Type !hang to start a new game.";
			}
			# 3 moves = 6 points
			elsif ($chaos->{clients}->{$client}->{_games}->{hang}->{moves} == 3) {
				$total_earned += 6;
				# Add the points to their record.
				&modPoints ($client,'+',$total_earned);

				return "Guessed after 3 moves. You get 6 points.\n\n"
					. "You've earned $total_earned points this round. "
					. "Type !hang to start a new game.";
			}
			# 4 moves = 4 points
			elsif ($chaos->{clients}->{$client}->{_games}->{hang}->{moves} == 4) {
				$total_earned += 4;
				# Add the points to their record.
				&modPoints ($client,'+',$total_earned);

				return "You figured it out after 4 moves. You get 4 points.\n\n"
					. "You've earned $total_earned points this round. "
					. "Type !hang to start a new game.";
			}
			# More... and you only get 2 points.
			else {
				$total_earned += 2;
				# Add the points to their record.
				&modPoints ($client,'+',$total_earned);

				return "You finally got it! You get 2 points!\n\n"
					. "You've earned $total_earned points this round. "
					. "Type !hang to start a new game.";
			}
		}
		elsif ($msg eq "exit") {
			delete $chaos->{clients}->{$client}->{callback};
			return "Alright, we're done playing Hangman.";
		}
		else {
			# See that they are guessing only one letter.
			$msg =~ s/[^A-Za-z0-9]//g;
			if (length $msg == 1) {
				# See if they've already guessed this letter.
				if ($chaos->{clients}->{$client}->{_games}->{hang}->{guess} =~ /$msg/i) {
					return "You've already chosen that letter.";
				}

				# Add this to their list of chosen letters.
				$chaos->{clients}->{$client}->{_games}->{hang}->{guess} .= $msg;

				# See if their word contains this letter.
				my $count = 0;
				my @places;
				if ($chaos->{clients}->{$client}->{_games}->{hang}->{word} =~ /$msg/i) {
					# Good. Let's get the places to fill in.
					my @chars = split(//, $chaos->{clients}->{$client}->{_games}->{hang}->{word});
					foreach my $symbol (@chars) {
						if ($msg eq $symbol) {
							push @places, $count;
						}
						$count++;
					}

					# Fill in the blanks.
					$count = 0;
					my @blanks = split(/ /, $chaos->{clients}->{$client}->{_games}->{hang}->{view});
					foreach my $place (@places) {
						$blanks[$place] = $msg;
					}
					$chaos->{clients}->{$client}->{_games}->{hang}->{view} = CORE::join (" ", @blanks);

					# See if they've completed the puzzle.
					if ($chaos->{clients}->{$client}->{_games}->{hang}->{view} !~ /\_/) {
						delete $chaos->{clients}->{$client}->{callback};
						return "Congratulations! You've solved the puzzle ("
							. $chaos->{clients}->{$client}->{_games}->{hang}->{word}
							. ")!\n\n"
							. "Type !hang to play again!";
					}
				}
				else {
					# They got it wrong. Add one to their wrong count.
					$chaos->{clients}->{$client}->{_games}->{hang}->{error} .= $msg;
					$chaos->{clients}->{$client}->{_games}->{hang}->{wrong}++;
				}

				# Get them their reply.
				my $bad_count = $chaos->{clients}->{$client}->{_games}->{hang}->{wrong};
				my $man;
				if ($bad_count == 0) {
					$man = " +---+\n"
						. " |\n"
						. " |\n"
						. " |\n"
						. " |\n"
						. " |\n"
						. " |\n"
						. " +-------";
				}
				elsif ($bad_count == 1) {
					$man = " +---+\n"
						. " |   |\n"
						. " |   O\n"
						. " |\n"
						. " |\n"
						. " |\n"
						. " |\n"
						. " +-------";
				}
				elsif ($bad_count == 2) {
					$man = " +---+\n"
						. " |   |\n"
						. " |   O\n"
						. " |   |\n"
						. " |\n"
						. " |\n"
						. " |\n"
						. " +-------";
				}
				elsif ($bad_count == 3) {
					$man = " +---+\n"
						. " |   |\n"
						. " |   O\n"
						. " |   |\n"
						. " |   |\n"
						. " |\n"
						. " |\n"
						. " +-------";
				}
				elsif ($bad_count == 4) {
					$man = " +---+\n"
						. " |   |\n"
						. " |   O\n"
						. " |  /|\n"
						. " |   |\n"
						. " |\n"
						. " |\n"
						. " +-------";
				}
				elsif ($bad_count == 5) {
					$man = " +---+\n"
						. " |   |\n"
						. " |   O\n"
						. " |  /|\\\n"
						. " |   |\n"
						. " |\n"
						. " |\n"
						. " +-------";
				}
				elsif ($bad_count == 6) {
					$man = " +---+\n"
						. " |   |\n"
						. " |   O\n"
						. " |  /|\\\n"
						. " |   |\n"
						. " |  /\n"
						. " |\n"
						. " +-------";
				}
				elsif ($bad_count == 7) {
					$man = " +---+\n"
						. " |   |\n"
						. " |   O\n"
						. " |  /|\\\n"
						. " |   |\n"
						. " |  / \\\n"
						. " |\n"
						. " +-------";
				}
				$reply = "<b>Hangman</b>\n"
					. "$man\n"
					. $chaos->{clients}->{$client}->{_games}->{hang}->{view} . "\n"
					. "Guessed: " . $chaos->{clients}->{$client}->{_games}->{hang}->{guess} . "\n"
					. "Wrong: " . $chaos->{clients}->{$client}->{_games}->{hang}->{error};
				if ($bad_count >= 7) {
					$reply .= "\n\nYou have lost. Your word was: "
						. $chaos->{clients}->{$client}->{_games}->{hang}->{word};
					delete $chaos->{clients}->{$client}->{callback};
				}
			}
			else {
				$chaos->{clients}->{$client}->{_games}->{hang}->{wrong}++;

				my $bad_count = $chaos->{clients}->{$client}->{_games}->{hang}->{wrong};
				my $man;
				if ($bad_count == 0) {
					$man = " +---+\n"
						. " |\n"
						. " |\n"
						. " |\n"
						. " |\n"
						. " |\n"
						. " |\n"
						. " +-------";
				}
				elsif ($bad_count == 1) {
					$man = " +---+\n"
						. " |   |\n"
						. " |   O\n"
						. " |\n"
						. " |\n"
						. " |\n"
						. " |\n"
						. " +-------";
				}
				elsif ($bad_count == 2) {
					$man = " +---+\n"
						. " |   |\n"
						. " |   O\n"
						. " |   |\n"
						. " |\n"
						. " |\n"
						. " |\n"
						. " +-------";
				}
				elsif ($bad_count == 3) {
					$man = " +---+\n"
						. " |   |\n"
						. " |   O\n"
						. " |   |\n"
						. " |   |\n"
						. " |\n"
						. " |\n"
						. " +-------";
				}
				elsif ($bad_count == 4) {
					$man = " +---+\n"
						. " |   |\n"
						. " |   O\n"
						. " |  /|\n"
						. " |   |\n"
						. " |\n"
						. " |\n"
						. " +-------";
				}
				elsif ($bad_count == 5) {
					$man = " +---+\n"
						. " |   |\n"
						. " |   O\n"
						. " |  /|\\\n"
						. " |   |\n"
						. " |\n"
						. " |\n"
						. " +-------";
				}
				elsif ($bad_count == 6) {
					$man = " +---+\n"
						. " |   |\n"
						. " |   O\n"
						. " |  /|\\\n"
						. " |   |\n"
						. " |  /\n"
						. " |\n"
						. " +-------";
				}
				elsif ($bad_count == 7) {
					$man = " +---+\n"
						. " |   |\n"
						. " |   O\n"
						. " |  /|\\\n"
						. " |   |\n"
						. " |  / \\\n"
						. " |\n"
						. " +-------";
				}

				if ($bad_count >= 7) {
					$reply = "<b>Hangman</b>\n$man\n\n"
						. $chaos->{clients}->{$client}->{_games}->{hang}->{view} . "\n"
						. "Guessed: " . $chaos->{clients}->{$client}->{_games}->{hang}->{guess} . "\n"
						. "Wrong: " . $chaos->{clients}->{$client}->{_games}->{hang}->{error} . "\n\n"
						. "You have run out of moves! Your word was: $chaos->{clients}->{$client}->{_games}->{hang}->{word}. "
						. "Type !hang to play again.";
					delete $chaos->{clients}->{$client}->{callback};
				}
				else {
					$reply = "<b>Hangman</b>\n$man\n\n"
						. $chaos->{clients}->{$client}->{_games}->{hang}->{view} . "\n"
						. "Guessed: " . $chaos->{clients}->{$client}->{_games}->{hang}->{guess} . "\n"
						. "Wrong: " . $chaos->{clients}->{$client}->{_games}->{hang}->{error} . "\n\n"
						. "Nope, that's not the word. Type 'exit' to stop playing Hangman.";
				}
			}
		}
	}
	else {
		# Start a new game. Here's our list of words.
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

		# Choose a random word and setup variables.
		my $choice = $words [ int(rand(scalar(@words))) ];
		$chaos->{clients}->{$client}->{_games}->{hang}->{word} = $choice;
		$chaos->{clients}->{$client}->{_games}->{hang}->{guess} = "";
		$chaos->{clients}->{$client}->{_games}->{hang}->{error} = "";
		$chaos->{clients}->{$client}->{_games}->{hang}->{wrong} = 0;
		$chaos->{clients}->{$client}->{_games}->{hang}->{view} = "";
		$chaos->{clients}->{$client}->{_games}->{hang}->{moves} = -1;

		# Get the length of the word.
		my $length = length $choice;
		my @items;
		while ($length > 0) {
			push @items, "_";
			$length--;
		}
		$chaos->{clients}->{$client}->{_games}->{hang}->{view} = CORE::join (" ", @items);

		# Tell them the word.
		$reply = "<b>Hangman</b>\n"
			. " +---+\n"
			. " |\n"
			. " |\n"
			. " |\n"
			. " |\n"
			. " |\n"
			. " |\n"
			. " +-------\n\n"
			. $chaos->{clients}->{$client}->{_games}->{hang}->{view} . "\n";

		print "Debug // Word Choice: " . $chaos->{clients}->{$client}->{_games}->{hang}->{word} . "\n";
		print "Debug // Guesses: " . $chaos->{clients}->{$client}->{_games}->{hang}->{guess} . "\n";
		print "Debug // Wrong: " . $chaos->{clients}->{$client}->{_games}->{hang}->{wrong} . "\n";
		print "Debug // View: " . $chaos->{clients}->{$client}->{_games}->{hang}->{view} . "\n";

		# Set the callback.
		$chaos->{clients}->{$client}->{callback} = "hang";
	}

	# Send the message using our monospaced font.
	if ($listener eq "AIM") {
		$reply = "<font face=\"$font\" size=\"2\">$reply</font></body>";
		return $reply;
	}
	elsif ($listener eq "MSN") {
		$self->sendmsg ($reply,Font => "$font",Color => "000000");
		return "$reply\n\n<noreply>";
	}
	elsif ($listener eq "HTTP") {
		$reply = "<font face=\"$font\" size=\"2\" color=\"black\">$reply</font></body>";
		return $reply;
	}
	else {
		return $reply;
	}
}
{
	Category    => 'Single-Player Games',
	Description => 'Hangman',
	Usage       => '!hang',
	Listener    => 'All',
};