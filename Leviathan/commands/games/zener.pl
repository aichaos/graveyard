#      .   .               <Leviathan>
#     .:...::     Command Name // !zener
#    .::   ::.     Description // Zener Card Designs.
# ..:;;. ' .;;:..        Usage // !zener
#    .  '''  .     Permissions // Public.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub zener {
	my ($self,$client,$msg) = @_;

	# If they're in the callback...
	if ($chaos->{clients}->{$client}->{callback} eq "zener") {
		# Exiting?
		if ($msg eq "exit") {
			delete $chaos->{clients}->{$client}->{_zener};
			delete $chaos->{clients}->{$client}->{callback};

			return "We are done with the Zener Cards for now.";
		}

		# See if their message is valid.
		$msg = lc($msg);
		$msg =~ s/ //g;
		if (exists $chaos->{clients}->{$client}->{_zener}->{deck}->{$msg}) {
			# See if they got it.
			if ($msg eq $chaos->{clients}->{$client}->{_zener}->{held}) {
				$chaos->{clients}->{$client}->{_zener}->{correct}++;
			}

			# Pick a new one.
			$chaos->{clients}->{$client}->{_zener}->{count}++;

			# If done...
			if ($chaos->{clients}->{$client}->{_zener}->{count} > 25) {
				my $correct = $chaos->{clients}->{$client}->{_zener}->{correct};
				delete $chaos->{clients}->{$client}->{_zener};
				delete $chaos->{clients}->{$client}->{callback};

				my $points = 0;

				# If they got more than 5 right, reward them.
				if ($correct > 5) {
					# They only get points for cards past 5, 10 points per card.
					my $count = $correct - 5;

					# Only a maximum of 14 cards can be accepted (that's still a
					# freaking huge number, 10^14 = 100,000,000,000,000 points).
					$count = 14 if $count > 14;

					# Points given: ten to the power of $count.
					$points = 10 ** $count;

					# Add their points.
					&modPoints ($client,'+',$points);
				}

				return "And that's all the cards!\n\n"
					. "You got $correct/25 "
					. "cards correct!\n\n"
					. "On average, picking random cards will return that you would "
					. "only get 5 of 25 cards correct. Persistent accuracy above that "
					. "is a sign of a form of ESP, Telepathy.\n\n"
					. "It is impossible to read a computer's mind, telepathy is a "
					. "two-way system. This game was only for fun.\n\n"
					. "You have earned $points points from this game (points are only "
					. "awarded if you guess more than 5 correctly).";
			}

			my @cards = qw (curve star cross square circle);
			my $chosen = '';
			while (length $chosen == 0) {
				my $pick = $cards [ int(rand(scalar(@cards))) ];

				if ($chaos->{clients}->{$client}->{_zener}->{deck}->{$pick} > 0) {
					$chaos->{clients}->{$client}->{_zener}->{deck}->{$pick}--;
					$chaos->{clients}->{$client}->{_zener}->{held} = $pick;
					$chosen = $pick;
				}
			}

			print "Debug // Chosen Card: $chosen\n";

			# Return.
			return "I have chosen a new card.\n\n"
				. "Card #$chaos->{clients}->{$client}->{_zener}->{count} / 25\n"
				. "(curve, star, cross, square, circle)";
		}
		else {
			return "Invalid card type. Type \"exit\" to quit. I still have the same "
				. "card. Which card is it?\n"
				. "(curve, star, cross, square, circle)";
		}
	}
	else {
		# Delete any pre-existing data.
		delete $chaos->{clients}->{$client}->{_zener};

		# Create a deck of cards.
		$chaos->{clients}->{$client}->{_zener}->{deck}->{curve}  = 5;
		$chaos->{clients}->{$client}->{_zener}->{deck}->{star}   = 5;
		$chaos->{clients}->{$client}->{_zener}->{deck}->{cross}  = 5;
		$chaos->{clients}->{$client}->{_zener}->{deck}->{square} = 5;
		$chaos->{clients}->{$client}->{_zener}->{deck}->{circle} = 5;

		# Initial variables.
		$chaos->{clients}->{$client}->{_zener}->{correct} = 0;
		$chaos->{clients}->{$client}->{_zener}->{count} = 1;
		$chaos->{clients}->{$client}->{callback} = 'zener';

		# Pick a card to start.
		my @cards = qw (curve star cross square circle);
		my $pick = $cards [ int(rand(scalar(@cards))) ];
		$chaos->{clients}->{$client}->{_zener}->{deck}->{$pick}--;
		$chaos->{clients}->{$client}->{_zener}->{held} = $pick;

		print "Debug // Chosen Card: $pick\n";

		# Return.
		return ":: Zener Card Designs ::\n\n"
			. "This is a computer simulation of the Zener Card Designs. I have a deck "
			. "of 25 cards, 5 cards with each of 5 symbols (5 curves, 5 stars, 5 crosses, "
			. "5 squares, 5 circles). I will draw the cards randomly. You must read my "
			. "mind and figure out what the card is.\n\n"
			. "I have card #1 / 25. What card is it?\n"
			. "(curve, star, cross, square, circle)";
	}
}
{
	Category    => 'Single-Player Games',
	Description => 'Zener Card Designs',
	Usage       => '!zener',
	Listener    => 'All',
};