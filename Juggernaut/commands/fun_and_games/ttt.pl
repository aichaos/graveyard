#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !ttt
#    .::   ::.     Description // Tic, Tac, Toe.
# ..:;;. ' .;;:..        Usage // !ttt
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub ttt {
	my ($self,$client,$msg,$listener) = @_;

	# We'll need a monospaced font.
	my $font = "Courier New";

	# See if we're currently playing the game.
	if ($chaos->{_users}->{$client}->{callback} eq "ttt") {
		# Lowercase their message.
		$msg = lc($msg);

		if ($msg eq "exit") {
			delete $chaos->{_users}->{$client}->{callback};
			return "Alright, we're done playing.";
		}

		# Make sure it's a valid coordinate.
		my $isvalid = 0;
		my $draw = 0;
		my $voided = 0;
		my @valid_coordinates = (
			"a1", "a2", "a3",
			"b1", "b2", "b3",
			"c1", "c2", "c3",
		);
		foreach my $valid (@valid_coordinates) {
			if ($msg eq $valid) {
				$isvalid = 1;
			}
			if (length $chaos->{_users}->{$client}->{_games}->{ttt}->{$valid} > 0) {
				$voided++;
			}
		}

		if ($isvalid == 1) {
			# See if this coordinate is free.
			if ($chaos->{_users}->{$client}->{_games}->{ttt}->{$msg} eq "") {
				# Set this location.
				$chaos->{_users}->{$client}->{_games}->{ttt}->{$msg} = "X";
				$chaos->{_users}->{$client}->{_games}->{ttt}->{open} =~ s/$msg //ig;

				# Give our computer player a location.
				my @possible = split(/ /, $chaos->{_users}->{$client}->{_games}->{ttt}->{open});
				my $choice = $possible [ int(rand(scalar(@possible))) ];
				$choice =~ s/ //g;
				$chaos->{_users}->{$client}->{_games}->{ttt}->{$choice} = "O";

				# See if somebody won.
				my $who_wins;
				my @winners = (
					"a1-b1-c1",
					"a1-a2-a3",
					"a1-b2-c3",
					"b1-b2-b3",
					"c1-c2-c3",
					"a2-b2-c2",
					"a3-b3-c3",
					"c1-b2-a3",
				);
				foreach my $winner (@winners) {
					my ($a,$b,$c) = split(/\-/, $winner);

					if ($chaos->{_users}->{$client}->{_games}->{ttt}->{$a} eq "X" &&
					$chaos->{_users}->{$client}->{_games}->{ttt}->{$b} eq "X" &&
					$chaos->{_users}->{$client}->{_games}->{ttt}->{$c} eq "X") {
						# Human wins.
						$who_wins = "p";
					}
					elsif ($chaos->{_users}->{$client}->{_games}->{ttt}->{$a} eq "O" &&
					$chaos->{_users}->{$client}->{_games}->{ttt}->{$b} eq "O" &&
					$chaos->{_users}->{$client}->{_games}->{ttt}->{$c} eq "O") {
						# Computer wins.
						$who_wins = "c";
					}
				}

				# Set our board up.
				my $caa = $chaos->{_users}->{$client}->{_games}->{ttt}->{a1} || "_";
				my $cab = $chaos->{_users}->{$client}->{_games}->{ttt}->{a2} || "_";
				my $cac = $chaos->{_users}->{$client}->{_games}->{ttt}->{a3} || " ";
				my $cba = $chaos->{_users}->{$client}->{_games}->{ttt}->{b1} || "_";
				my $cbb = $chaos->{_users}->{$client}->{_games}->{ttt}->{b2} || "_";
				my $cbc = $chaos->{_users}->{$client}->{_games}->{ttt}->{b3} || " ";
				my $cca = $chaos->{_users}->{$client}->{_games}->{ttt}->{c1} || "_";
				my $ccb = $chaos->{_users}->{$client}->{_games}->{ttt}->{c2} || "_";
				my $ccc = $chaos->{_users}->{$client}->{_games}->{ttt}->{c3} || " ";
				$reply = "<b>Tic, Tac, Toe</b>\n\n"
					. "  A B C\n"
					. "1 $caa|$cba|$cca\n"
					. "2 $cab|$cbb|$ccb\n"
					. "3 $cac|$cbc|$ccc\n";

				# See if we have a winner.
				if ($who_wins eq "p") {
					# Get our number of points...
					my $points = 0;
					$points++ if $caa eq "X";
					$points++ if $cba eq "X";
					$points++ if $cca eq "X";
					$points++ if $cab eq "X";
					$points++ if $cbb eq "X";
					$points++ if $ccb eq "X";
					$points++ if $cac eq "X";
					$points++ if $cbc eq "X";
					$points++ if $ccc eq "X";
					$reply .= "\nRemote Player ($client) wins! You have earned $points points! :-)";
					delete $chaos->{_users}->{$client}->{callback};
					&point_manager ($client,$listener,'+',$points);
				}
				elsif ($who_wins eq "c") {
					$reply .= "\nLocal Player (robot) wins!";
					delete $chaos->{_users}->{$client}->{callback};
				}

				# Or if it's a draw...
				if ($voided == 9) {
					return "All spaces are taken! This game ended in a draw!";
				}
			}
			else {
				$reply = "That space is not available.";
			}
		}
		else {
			$reply = "That is not a valid coordinate. A valid coordinate looks like: A1\n\n"
				. "Type a valid coordinate to continue, or type 'exit' to quit.";
		}
	}
	else {
		# Start a new game.
		$chaos->{_users}->{$client}->{_games}->{ttt}->{a1} = "";
		$chaos->{_users}->{$client}->{_games}->{ttt}->{a2} = "";
		$chaos->{_users}->{$client}->{_games}->{ttt}->{a3} = "";
		$chaos->{_users}->{$client}->{_games}->{ttt}->{b1} = "";
		$chaos->{_users}->{$client}->{_games}->{ttt}->{b2} = "";
		$chaos->{_users}->{$client}->{_games}->{ttt}->{b3} = "";
		$chaos->{_users}->{$client}->{_games}->{ttt}->{c1} = "";
		$chaos->{_users}->{$client}->{_games}->{ttt}->{c2} = "";
		$chaos->{_users}->{$client}->{_games}->{ttt}->{c3} = "";
		$chaos->{_users}->{$client}->{_games}->{ttt}->{open} = "a1 a2 a3 b1 b2 b3 c1 c2 c3 ";
		$chaos->{_users}->{$client}->{_games}->{ttt}->{moves} = 0;

		# Set the callback.
		$chaos->{_users}->{$client}->{callback} = "ttt";

		$reply = "<b>Tic, Tac, Toe</b>\n\n"
			. "  A B C\n"
			. "1 _|_|_\n"
			. "2 _|_|_\n"
			. "3  | | \n\n"
			. "Type the coordinate of the location you want to place your X "
			. "(eg. B3)";
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
	else {
		$reply = "<font face=\"$font\" size=\"2\" color=\"black\">$reply</font></body>";
		return $reply;
	}
}

{
	Category => 'Fun & Games',
	Description => 'Tic, Tac, Toe',
	Usage => '!ttt',
	Listener => 'All',
};