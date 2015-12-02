#      .   .	     <Leviathan>
#     .:...::     Command Name // !ttt
#    .::   ::.     Description // Tic Tac Toe.
# ..:;;. ' .;;:..        Usage // !ttt
#    .  '''  .     Permissions // Public.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub ttt {
	my ($self,$client,$msg) = @_;

	# Monospaced font to use.
	my $font = 'Courier New';

	my $reply;

	my %levels = (
		1 => 'Computer is totally stupid',
		2 => 'Computer is slightly smarter',
		3 => 'You <i>MIGHT</i> win',
		4 => 'Computer NEVER loses',
	);

	# Number of points to reward for beating certain difficulties.
	my %pts = (
		1 => 0,
		2 => 25,
		3 => 100,
		4 => 1000,
	);

	# New game?
	if ($chaos->{clients}->{$client}->{callback} !~ /^ttt/i) {
		# Select a difficulty level.
		$chaos->{clients}->{$client}->{callback} = 'ttt';
		$chaos->{clients}->{$client}->{_ttt}->{status} = 'newgame';
		return ":: Tic, Tac, Toe ::\n\n"
			. "Select a difficulty level below (type the NUMBER next to "
			. "the corresponding option):\n\n"
			. "1 - $levels{1}\n"
			. "2 - $levels{2}\n"
			. "3 - $levels{3}\n"
			. "4 - $levels{4}";
	}

	# If they're JUST now selecting a difficulty.
	if ($chaos->{clients}->{$client}->{_ttt}->{status} eq 'newgame') {
		my $num = $msg;

		return "You can only send me a NUMBER as difficulty level (from 1 to 4). Type "
			. "$chaos->{config}->{command}ttt to see the list of difficulty levels."
			if $msg =~ /[^0-9]/;

		return "Bad range. Difficulty levels range from 1 to 4." if ($num < 1 || $num > 4);

		$chaos->{clients}->{$client}->{_ttt}->{level} = $num;
		$chaos->{clients}->{$client}->{_ttt}->{strat} = 0;      # For level 4.

		# Initilization.
		$chaos->{clients}->{$client}->{callback} = "ttt";
		$chaos->{clients}->{$client}->{_ttt}->{status} = "playing";
		$chaos->{clients}->{$client}->{_ttt}->{a1} = '_';
		$chaos->{clients}->{$client}->{_ttt}->{a2} = '_';
		$chaos->{clients}->{$client}->{_ttt}->{a3} = ' ';
		$chaos->{clients}->{$client}->{_ttt}->{b1} = '_';
		$chaos->{clients}->{$client}->{_ttt}->{b2} = '_';
		$chaos->{clients}->{$client}->{_ttt}->{b3} = ' ';
		$chaos->{clients}->{$client}->{_ttt}->{c1} = '_';
		$chaos->{clients}->{$client}->{_ttt}->{c2} = '_';
		$chaos->{clients}->{$client}->{_ttt}->{c3} = ' ';

		# Return the starting board.
		$reply = "Difficulty Level $chaos->{clients}->{$client}->{_ttt}->{level}\n\n"
			. "  A B C\n"
			. "1 _|_|_\n"
			. "2 _|_|_\n"
			. "3  | | \n\n"
			. "Choose a coordinate (i.e. A2 or C3)";
	}
	elsif ($chaos->{clients}->{$client}->{_ttt}->{status} eq 'playing') {
		# Quitting?
		if ($msg =~ /quit/i) {
			delete $chaos->{clients}->{$client}->{_ttt};
			delete $chaos->{clients}->{$client}->{callback};
			return "Game has been forfeited by remote player.";
		}

		# Playing the game.
		return "Give me a coordinate!" if length $msg == 0;

		# Make sure their coordinate is valid.
		return "Invalid coordinate: coordinates are 2 characters long (ex. A3)" if length $msg > 2;
		my ($letter,$num) = split(//, $msg, 2);
		return "Invalid coordinate: must be one letter and one number (ex. A3)" if $letter =~ /[^ABCabc]/;
		return "Invalid coordinate: must be one letter and one number (ex. A3)" if $num =~ /[^0-9]/;

		$msg = lc($msg);

		# Array of ways to win.
		my @ways = (
			'a1,b1,c1',
			'a1,b2,c3',
			'a1,a2,a3',
			'a2,b2,c2',
			'a3,b3,c3',
			'b1,b2,b3',
			'c1,b2,a3',
			'c1,c2,c3',
		);
		# Array of all options.
		my @opts = (
			'a1', 'b1', 'c1',
			'a2', 'b2', 'c2',
			'a3', 'b3', 'c3',
		);

		# Make sure the selected place is free.
		if ($chaos->{clients}->{$client}->{_ttt}->{$msg} ne '_' && $chaos->{clients}->{$client}->{_ttt}->{$msg} ne ' ') {
			return "That space is not available!";
		}

		# Draw?
		my $filled = 0;
		foreach my $place (@opts) {
			my $value = $chaos->{clients}->{$client}->{_ttt}->{$place};
			if ($value ne '_' && $value ne ' ') {
				$filled++;
			}
		}
		if ($filled >= 7) { # 7 now, plus 1 human and 1 computer = 9
			delete $chaos->{clients}->{$client}->{_ttt};
			delete $chaos->{clients}->{$client}->{callback};
			return "This game is a draw.";
		}

		# Mark them in that space.
		$chaos->{clients}->{$client}->{_ttt}->{$msg} = 'X';

		my %marks = (
			a1 => $chaos->{clients}->{$client}->{_ttt}->{a1},
			b1 => $chaos->{clients}->{$client}->{_ttt}->{b1},
			c1 => $chaos->{clients}->{$client}->{_ttt}->{c1},
			a2 => $chaos->{clients}->{$client}->{_ttt}->{a2},
			b2 => $chaos->{clients}->{$client}->{_ttt}->{b2},
			c2 => $chaos->{clients}->{$client}->{_ttt}->{c2},
			a3 => $chaos->{clients}->{$client}->{_ttt}->{a3},
			b3 => $chaos->{clients}->{$client}->{_ttt}->{b3},
			c3 => $chaos->{clients}->{$client}->{_ttt}->{c3},
		);

		# See if somebody won.
		foreach my $win (@ways) {
			last if length $reply > 0;
			my ($a,$b,$c) = split(/\,/, $win, 3);
			my $one = $chaos->{clients}->{$client}->{_ttt}->{$a};
			my $two = $chaos->{clients}->{$client}->{_ttt}->{$b};
			my $three = $chaos->{clients}->{$client}->{_ttt}->{$c};

			# If the three match...
			if ($one eq $two && $one eq $three && $one ne '_' && $one ne ' ') {
				# Start the reply.
				$reply = "Difficulty Level $chaos->{clients}->{$client}->{_ttt}->{level}\n\n"
					. "  A B C\n"
					. "1 $marks{a1}|$marks{b1}|$marks{c1}\n"
					. "2 $marks{a2}|$marks{b2}|$marks{c2}\n"
					. "3 $marks{a3}|$marks{b3}|$marks{c3}\n\n";

				if ($one eq 'X') {
					# Player wins!
					# Give them points.
					my $level = $chaos->{clients}->{$client}->{_ttt}->{level};
					my $points = $pts{$level};
					if ($points > 0) {
						&modPoints($client,'+',$points);
					}

					delete $chaos->{clients}->{$client}->{_ttt};
					delete $chaos->{clients}->{$client}->{callback};
					$reply .= "Remote Player ($client) has won! Given $points points.";
				}
				else {
					# Computer wins!
					delete $chaos->{clients}->{$client}->{_ttt};
					delete $chaos->{clients}->{$client}->{callback};
					$reply .= "Local Player (computer) has won!";
				}
			}
		}

		# Now for the computer's turn.
		my $level = $chaos->{clients}->{$client}->{_ttt}->{level};


		# Level 1 - Randomly pick a spot.
		# Level 2 - Randomly pick spot; and randomly stop a 2-in-a-row from user.
		# Level 3 - Strategically pick spot; always stop a 2-in-a-row from user.
		# Level 4 - Always pick two-way methods; always stop 2-in-a-row from user.
		my $chosen = 0;
		my $give = 200;
		if ($level == 1) {
			# Until a spot is available...
			while ($chosen == 0) {
				my $choice = $opts [ int(rand(scalar(@opts))) ];
				my $value = $chaos->{clients}->{$client}->{_ttt}->{$choice};

				# If available...
				if ($value eq '_' || $value eq ' ') {
					# Set it!
					$chosen = 1;
					$chaos->{clients}->{$client}->{_ttt}->{$choice} = 'O';
				}
				else {
					# Try again...
					$give--;

					if ($give <= 0) {
						# Give up.
						delete $chaos->{clients}->{$client}->{_ttt};
						delete $chaos->{clients}->{$client}->{callback};
						return "Unknown error: game has been terminated.";
					}
				}
			}
		}
		elsif ($level == 2) {
			# Probability of stopping a 2-in-a-row: 1 in 3.
			my $stop = int(rand(3)) + 1;
			if ($stop == 1) {
				# Check for two-in-a-row's from the user.
				foreach my $path (@ways) {
					last if $chosen == 1;
					my ($a,$b,$c) = split(/\,/, $path, 3);
					my $one = $chaos->{clients}->{$client}->{_ttt}->{$a};
					my $two = $chaos->{clients}->{$client}->{_ttt}->{$b};
					my $three = $chaos->{clients}->{$client}->{_ttt}->{$c};

					# Combinations: 1 & 2, 1 & 3, 2 & 3
					if ($one eq 'X' && $one eq $two && $three ne 'O') {
						# Steal spot three!
						$chaos->{clients}->{$client}->{_ttt}->{$c} = 'O';
						$chosen = 1;
					}
					elsif ($one eq 'X' && $one eq $three && $two ne 'O') {
						# Steal spot two!
						$chaos->{clients}->{$client}->{_ttt}->{$b} = 'O';
						$chosen = 1;
					}
					elsif ($two eq 'X' && $two eq $three && $one ne 'O') {
						# Steal spot one!
						$chaos->{clients}->{$client}->{_ttt}->{$a} = 'O';
						$chosen = 1;
					}
				}
			}

			# Now randomly choose a spot.
			while ($chosen == 0) {
				my $choice = $opts [ int(rand(scalar(@opts))) ];
				my $value = $chaos->{clients}->{$client}->{_ttt}->{$choice};

				# If available...
				if ($value eq '_' || $value eq ' ') {
					# Set it!
					$chosen = 1;
					$chaos->{clients}->{$client}->{_ttt}->{$choice} = 'O';
				}
				else {
					# Try again...
					$give--;

					if ($give <= 0) {
						# Give up.
						delete $chaos->{clients}->{$client}->{_ttt};
						delete $chaos->{clients}->{$client}->{callback};
						return "Unknown error: game has been terminated.";
					}
				}
			}
		}
		elsif ($level == 3) {
			# Always stop two-in-a-row's from the user.
			foreach my $path (@ways) {
				last if $chosen == 1;
				my ($a,$b,$c) = split(/\,/, $path, 3);
				my $one = $chaos->{clients}->{$client}->{_ttt}->{$a};
				my $two = $chaos->{clients}->{$client}->{_ttt}->{$b};
				my $three = $chaos->{clients}->{$client}->{_ttt}->{$c};

				# Combinations: 1 & 2, 1 & 3, 2 & 3
				if ($one eq 'X' && $one eq $two && $three ne 'O') {
					# Steal spot three!
					$chaos->{clients}->{$client}->{_ttt}->{$c} = 'O';
					$chosen = 1;
				}
				elsif ($one eq 'X' && $one eq $three && $two ne 'O') {
					# Steal spot two!
					$chaos->{clients}->{$client}->{_ttt}->{$b} = 'O';
					$chosen = 1;
				}
				elsif ($two eq 'X' && $two eq $three && $one ne 'O') {
					# Steal spot one!
					$chaos->{clients}->{$client}->{_ttt}->{$a} = 'O';
					$chosen = 1;
				}
			}

			# Strategically select a spot.
			foreach my $path (@ways) {
				last if $chosen == 1;
				my ($a,$b,$c) = split(/\,/, $path, 3);
				my $one = $chaos->{clients}->{$client}->{_ttt}->{$a};
				my $two = $chaos->{clients}->{$client}->{_ttt}->{$b};
				my $three = $chaos->{clients}->{$client}->{_ttt}->{$c};

				# Try to find open paths (---, O--, -O-, --O, O-O, OO-, -OO
				if ($one ne 'X' && $one ne 'O' && $two ne 'X' && $two ne 'O' && $three ne 'X' && $three ne 'O') {
					# - - -
					# Pick the middle one.
					$chaos->{clients}->{$client}->{_ttt}->{$b} = 'O';
					$chosen = 1;
				}
				elsif ($one eq 'O' && $two ne 'X' && $two ne 'O' && $three ne 'X' && $three ne 'O') {
					# O - -
					# Steal the third.
					$chaos->{clients}->{$client}->{_ttt}->{$c} = 'O';
					$chosen = 1;
				}
				elsif ($one ne 'X' && $one ne 'O' && $two eq 'O' && $three ne 'X' && $three ne 'O') {
					# - O -
					# Steal the first.
					$chaos->{clients}->{$client}->{_ttt}->{$a} = 'O';
					$chosen = 1;
				}
				elsif ($one ne 'X' && $one ne 'O' && $two ne 'X' && $two ne 'O' && $three ne 'X') {
					# - - O
					# Steal the first.
					$chaos->{clients}->{$client}->{_ttt}->{$a} = 'O';
					$chosen = 1;
				}
				elsif ($one eq 'O' && $two ne 'O' && $two ne 'X' && $three eq 'O') {
					# O - O
					# Finish!
					$chaos->{clients}->{$client}->{_ttt}->{$b} = 'O';
					$chosen = 1;
				}
				elsif ($one eq 'O' && $two eq 'O' && $three ne 'X') {
					# O O -
					# Finish!
					$chaos->{clients}->{$client}->{_ttt}->{$c} = 'O';
					$chosen = 1;
				}
				elsif ($one ne 'X' && $two eq 'O' && $three eq 'O') {
					# - O O
					# Finish!
					$chaos->{clients}->{$client}->{_ttt}->{$a} = 'O';
					$chosen = 1;
				}
			}

			# If we can't think (or are doomed to not win), pick one randomly again.
			while ($chosen == 0) {
				my $choice = $opts [ int(rand(scalar(@opts))) ];
				my $value = $chaos->{clients}->{$client}->{_ttt}->{$choice};

				# If available...
				if ($value eq '_' || $value eq ' ') {
					# Set it!
					$chosen = 1;
					$chaos->{clients}->{$client}->{_ttt}->{$choice} = 'O';
				}
				else {
					# Try again...
					$give--;

					if ($give <= 0) {
						# Give up.
						delete $chaos->{clients}->{$client}->{_ttt};
						delete $chaos->{clients}->{$client}->{callback};
						return "Unknown error: game has been terminated.";
					}
				}
			}
		}
		elsif ($level == 4) {
			# Always stop two-in-a-row's from the user.
			foreach my $path (@ways) {
				last if $chosen == 1;
				my ($a,$b,$c) = split(/\,/, $path, 3);
				my $one = $chaos->{clients}->{$client}->{_ttt}->{$a};
				my $two = $chaos->{clients}->{$client}->{_ttt}->{$b};
				my $three = $chaos->{clients}->{$client}->{_ttt}->{$c};

				# Combinations: 1 & 2, 1 & 3, 2 & 3
				if ($one eq 'X' && $one eq $two && $three ne 'O') {
					# Steal spot three!
					$chaos->{clients}->{$client}->{_ttt}->{$c} = 'O';
					$chosen = 1;
				}
				elsif ($one eq 'X' && $one eq $three && $two ne 'O') {
					# Steal spot two!
					$chaos->{clients}->{$client}->{_ttt}->{$b} = 'O';
					$chosen = 1;
				}
				elsif ($two eq 'X' && $two eq $three && $one ne 'O') {
					# Steal spot one!
					$chaos->{clients}->{$client}->{_ttt}->{$a} = 'O';
					$chosen = 1;
				}
			}

			# The strategy.
			my @stat = (
				'a1,c3,a3',
				'a1,c3,c1',
				'c1,a3,c3',
				'c1,a3,a1',
			);

			# See if a strategy is available. If not, we can always prevent the human from winning!
			foreach my $path (@strat) {
				last if $chosen == 1;
				my ($a,$b,$c) = split(/\,/, $path, 3);
				my $one = $chaos->{clients}->{$client}->{_ttt}->{$a};
				my $two = $chaos->{clients}->{$client}->{_ttt}->{$b};
				my $three = $chaos->{clients}->{$client}->{_ttt}->{$c};

				# See if this strategy is going to work first.
				if ($chaos->{clients}->{$client}->{_ttt}->{strat} == 0) {
					if ($one ne 'X' && $two ne 'X' && $three ne 'X') {
						# This one looks good.
						$chaos->{clients}->{$client}->{_ttt}->{strat} = $path;
					}
					else {
						# No... better luck next time.
						$chaos->{clients}->{$client}->{_ttt}->{strat} = 'failed';
					}
				}
			}

			# We can still prevent the human from winning!
			while ($chosen == 0) {
				my $choice = $opts [ int(rand(scalar(@opts))) ];
				my $value = $chaos->{clients}->{$client}->{_ttt}->{$choice};

				# If available...
				if ($value eq '_' || $value eq ' ') {
					# Set it!
					$chosen = 1;
					$chaos->{clients}->{$client}->{_ttt}->{$choice} = 'O';
				}
				else {
					# Try again...
					$give--;

					if ($give <= 0) {
						# Give up.
						delete $chaos->{clients}->{$client}->{_ttt};
						delete $chaos->{clients}->{$client}->{callback};
						return "Unknown error: game has been terminated.";
					}
				}
			}
		}
		else {
			$reply = "Not yet implemented." unless length $reply > 0;
		}

		%marks = (
			a1 => $chaos->{clients}->{$client}->{_ttt}->{a1},
			b1 => $chaos->{clients}->{$client}->{_ttt}->{b1},
			c1 => $chaos->{clients}->{$client}->{_ttt}->{c1},
			a2 => $chaos->{clients}->{$client}->{_ttt}->{a2},
			b2 => $chaos->{clients}->{$client}->{_ttt}->{b2},
			c2 => $chaos->{clients}->{$client}->{_ttt}->{c2},
			a3 => $chaos->{clients}->{$client}->{_ttt}->{a3},
			b3 => $chaos->{clients}->{$client}->{_ttt}->{b3},
			c3 => $chaos->{clients}->{$client}->{_ttt}->{c3},
		);

		# See if somebody won.
		foreach my $win (@ways) {
			last if length $reply > 0;
			my ($a,$b,$c) = split(/\,/, $win, 3);
			my $one = $chaos->{clients}->{$client}->{_ttt}->{$a};
			my $two = $chaos->{clients}->{$client}->{_ttt}->{$b};
			my $three = $chaos->{clients}->{$client}->{_ttt}->{$c};

			# If the three match...
			if ($one eq $two && $one eq $three && $one ne '_' && $one ne ' ') {
				# Start the reply.
				$reply = "Difficulty Level $chaos->{clients}->{$client}->{_ttt}->{level}\n\n"
					. "  A B C\n"
					. "1 $marks{a1}|$marks{b1}|$marks{c1}\n"
					. "2 $marks{a2}|$marks{b2}|$marks{c2}\n"
					. "3 $marks{a3}|$marks{b3}|$marks{c3}\n\n";

				if ($one eq 'X') {
					# Player wins!
					# Give them points.
					my $level = $chaos->{clients}->{$client}->{_ttt}->{level};
					my $points = $pts{$level};
					if ($points > 0) {
						&modPoints($client,'+',$points);
					}

					delete $chaos->{clients}->{$client}->{_ttt};
					delete $chaos->{clients}->{$client}->{callback};
					$reply .= "Remote Player ($client) has won! Given $points points.";
				}
				else {
					# Computer wins!
					delete $chaos->{clients}->{$client}->{_ttt};
					delete $chaos->{clients}->{$client}->{callback};
					$reply .= "Local Player (computer) has won!";
				}
			}
		}

		# Write out the board again.
		if (length $reply == 0) {
			my %board = (
				a1 => $chaos->{clients}->{$client}->{_ttt}->{a1},
				b1 => $chaos->{clients}->{$client}->{_ttt}->{b1},
				c1 => $chaos->{clients}->{$client}->{_ttt}->{c1},
				a2 => $chaos->{clients}->{$client}->{_ttt}->{a2},
				b2 => $chaos->{clients}->{$client}->{_ttt}->{b2},
				c2 => $chaos->{clients}->{$client}->{_ttt}->{c2},
				a3 => $chaos->{clients}->{$client}->{_ttt}->{a3},
				b3 => $chaos->{clients}->{$client}->{_ttt}->{b3},
				c3 => $chaos->{clients}->{$client}->{_ttt}->{c3},
			);
			$reply = "Difficulty Level $chaos->{clients}->{$client}->{_ttt}->{level}\n\n"
				. "  A B C\n"
				. "1 $board{a1}|$board{b1}|$board{c1}\n"
				. "2 $board{a2}|$board{b2}|$board{c2}\n"
				. "3 $board{a3}|$board{b3}|$board{c3}";
		}
	}
	else {
		return "Unknown error!";
	}

	# Send the reply.
	my ($listener,$nick) = split(/\-/, $client, 2);
	if ($listener eq 'AIM' || $listener eq 'TOC') {
		my $send = "<body bgcolor=\"#FFFFFF\"><font face=\"$font\" size=\"2\" color=\"#000000\">"
			. "$reply</font></body>";
		return $send;
	}
	elsif ($listener eq 'MSN') {
		$self->sendMessage ($reply,
			Font  => "$font",
			Color => '000000',
			Style => 'B',
		);
		return '<noreply>';
	}
	elsif ($listener eq 'HTTP') {
		my $send = "<font face=\"$font\" size=\"2\" color=\"#000000\">$reply</font>";
		return $send;
	}
	else {
		# Can't do much for it...
		return $reply;
	}
}
{
	Category    => 'Single-Player Games',
	Description => 'Tic Tac Toe',
	Usage       => '!ttt',
	Listener    => 'All',
};