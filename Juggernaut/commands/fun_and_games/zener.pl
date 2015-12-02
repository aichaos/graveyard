#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !zener
#    .::   ::.     Description // The Zener Card Designs game.
# ..:;;. ' .;;:..        Usage // !zener
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub zener {
	my ($self,$client,$msg,$listener) = @_;

	# Lowercase the message.
	$msg = lc($msg);

	# Array of cards.
	my @cards = (
		"star",
		"circle",
		"cross",
		"square",
		"waves",
	);

	# If they've already begun playing...
	if ($chaos->{_users}->{$client}->{callback} eq "zener") {
		# Special cases.
		if ($msg eq "about") {
			return ".: About Zener Cards :.\n\n"
				. "The Zener Cards were named after their creator, Karl Zener. They are "
				. "designed to help notice a form of ESP (Extra Sensory Perception), Telepathy.\n\n"
				. "Telepathy is the ability to read one's mind, in this case, the computer's.\n\n"
				. "In a standard Zener Card deck, there are 25 cards, five cards with one of "
				. "the five symbols on them:\n"
				. "5 Stars\n"
				. "5 Circles\n"
				. "5 Crosses\n"
				. "5 Squares\n"
				. "5 Waves\n\n"
				. "The computer in this game will pick a card ahead of time. It is your job "
				. "to try and read the computer's mind, and pick the card it chose.\n\n"
				. "Statistics show that the average non-telepathic person, choosing cards at "
				. "random, would get about 5 out of the 25 cards correct.\n\n"
				. "This is only a simulation; a game just for fun.";
		}
		elsif ($msg eq "exit") {
			# Exiting...
			foreach my $key (keys %{$chaos->{_users}->{$client}->{_zener}}) {
				delete $chaos->{_users}->{$client}->{_zener}->{$key};
			}
			delete $chaos->{_users}->{$client}->{_zener};
			delete $chaos->{_users}->{$client}->{callback};

			return "Okay, we're done playing this game.";
		}
		else {
			# See if they have a valid card.
			if ($msg eq "star" || $msg eq "circle" || $msg eq "cross" || $msg eq "square" || $msg eq "waves") {
				# See if they got our card.
				my $reply;
				if ($msg eq $chaos->{_users}->{$client}->{_zener}->{hold}) {
					$chaos->{_users}->{$client}->{_zener}->{right}++;
					$reply = "Yes! You got the card!";
				}
				else {
					$reply = "You did not get the right card.";
				}

				# Make sure we have another card to choose from.
				if ($chaos->{_users}->{$client}->{_zener}->{count} < 25) {
					# Pick a new card.
					my $found = 0;
					while ($found == 0) {
						my $choice = $cards [ int(rand(scalar(@cards))) ];
						if ($chaos->{_users}->{$client}->{_zener}->{$choice} > 0) {
							$chaos->{_users}->{$client}->{_zener}->{$choice}--;
							$chaos->{_users}->{$client}->{_zener}->{hold} = $choice;
							$chaos->{_users}->{$client}->{_zener}->{count}++;
							$found = 1;
						}
					}

					# Return this reply.
					$reply .= "\n\nI have chosen a new card (I have drawn "
						. "$chaos->{_users}->{$client}->{_zener}->{count} cards out of 25).\n"
						. "What card do I have?\n"
						. "(Star, Circle, Cross, Square, Waves)";
				}
				else {
					$reply .= "\n\nI am all out of cards. You correctly guessed a total of "
						. "$chaos->{_users}->{$client}->{_zener}->{right}/25 cards.";

					# If they got more than 6 cards right, give them 5 points for each card.
					if ($chaos->{_users}->{$client}->{_zener}->{right} > 5) {
						my $right = $chaos->{_users}->{$client}->{_zener}->{right};
						my $earn = $right * 5;
						&point_manager ($client,$listener,'+',$earn);
						$reply .= "\n\nYou have earned a total of $earn points from this game "
							. "(you get 5 points for each number of cards you correctly "
							. "guessed, if you guess more than 5 cards correctly)";
					}
				}

				# Return the reply.
				return $reply;
			}
			else {
				return "That's not a card type. The types are: Star, Circle, Cross, Square, and "
					. "Waves. Type 'exit' to stop playing.";
			}
		}
	}
	else {
		# Begin the game.
		$chaos->{_users}->{$client}->{callback} = "zener";

		# Create the deck.
		$chaos->{_users}->{$client}->{_zener}->{star} = 5;
		$chaos->{_users}->{$client}->{_zener}->{circle} = 5;
		$chaos->{_users}->{$client}->{_zener}->{cross} = 5;
		$chaos->{_users}->{$client}->{_zener}->{square} = 5;
		$chaos->{_users}->{$client}->{_zener}->{waves} = 5;

		# Start the game off.
		$chaos->{_users}->{$client}->{_zener}->{count} = 1;
		$chaos->{_users}->{$client}->{_zener}->{right} = 0;

		# Select our first card.
		my $first = $cards [ int(rand(scalar(@cards))) ];
		$chaos->{_users}->{$client}->{_zener}->{$first}--;
		$chaos->{_users}->{$client}->{_zener}->{hold} = $first;

		return ".: Zener Card Designs :.\n\n"
			. "I am going to randomly choose 25 cards from a deck that "
			. "contains 5 cards of 5 different types: Star, circle, cross, square, and waves. "
			. "Your job is to attempt to read my mind and choose the card I am holding.\n\n"
			. "For more information, type \"about\".\n\n"
			. "I have a card. Which card do I have?\n"
			. "(Star, Circle, Cross, Square, or Waves)";
	}
}

{
	Category => 'Fun & Games',
	Description => 'Zener Card Designs',
	Usage => '!zener',
	Listener => 'All',
};