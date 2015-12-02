#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !slots
#    .::   ::.     Description // Play the slot machines!
# ..:;;. ' .;;:..        Usage // !slots <points to bet>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub slots {
	my ($self,$client,$msg,$listener) = @_;

	# If they have a number to bet...
	if (length $msg > 0) {
		if ($msg =~ /[^0-9]/i) {
			return "You can only gamble a NUMBER of points. Or type 'exit' to quit.";
		}
		else {
			# If they don't even have 1, say so.
			if ($chaos->{_users}->{$client}->{points} <= 0) {
				return "You need more than 0 points to gamble. Type !pinfo for information "
					. "on how to earn points.";
			}

			# Make sure they have enough points TO gamble.
			if ($chaos->{_users}->{$client}->{points} >= $msg) {
				# Pick a random slots outcome.
				my $a1 = int(rand(7));
				my $a2 = int(rand(8));
				my $a3 = int(rand(9));
				my $b1 = int(rand(10));
				my $b2 = int(rand(10));
				my $b3 = int(rand(10));
				my $c1 = int(rand(8));
				my $c2 = int(rand(9));
				my $c3 = int(rand(10));

				my $roll = '*';

				my $result = "S L O T S\n"
					. "A :: $a1|$a2|$a3\n"
					. "B :: $b1|$b2|$b3\n"
					. "C :: $c1|$c2|$c3\n\n";

				# Possible ways to win:
				# -A row is the same number -- 8 points
				# -B row is the same number -- 10 points
				# -C row is the same number -- 6 points
				# -If you get at least one seven -- 3 points
				# -Diagonal -- 8 points
				# -Any row has all sevens: 50 points

				# Possible ways to lose:
				# -Any row has all zeros or all nines -- 10 points
				# -Diagonal of zeros -- 8 points
				# -Any row has all sixes -- 50 points (ouch!)
				# -Diagonal of sixes -- 30 points
				# -If you get at least one six -- 3 points

				#   W A Y S   T O
				#   #   #  #####  #   #
				#   #   #    #    ##  #
				#   #   #    #    # # #
				#   # # #    #    #  ##
				#    # #   #####  #   #
				#  ---------------------
				# See if A row has all the same numbers.
				my $earn = 0;
				if ($a1 == $a2 && $a1 == $a3) {
					# Earned 8 points.
					$earn += 8;
					$result .= "$roll Row A has all the same numbers! +8\n";
				}
				# See if row B has all the same numbers.
				if ($b1 == $b2 && $b2 == $b3) {
					# Earn 10 points.
					$earn += 10;
					$result .= "$roll Row B has all the same numbers! +10\n";
				}
				# See if row C has all the same numbers.
				if ($c1 == $c2 && $c2 == $c3) {
					# Earn 6 points.
					$earn += 6;
					$result .= "$roll Row C has all the same numbers! +6\n";
				}
				# See if we have a diagonal.
				if (($a1 == $b2 && $b2 == $c3) || ($a3 == $b2 && $b2 == $c1)) {
					# Earn 8 points.
					$earn += 8;
					$result .= "$roll You got a diagonal! +8\n";
				}
				# See if any row has all sevens.
				if (($a1 == 7 && $a2 == 7 && $a3 == 7) || ($b1 == 7 && $b2 == 7 && $b3 == 7) ||
				($c1 == 7 && $c2 == 7 && $c3 == 7)) {
					# Earn 50 points.
					$earn += 50;
					$result .= "$roll You have a row of 7's! +50\n";
				}
				# See if there's at least one seven.
				if ($a1 == 7 || $a2 == 7 || $a3 == 7 || $b1 == 7 || $b2 == 7 || $b3 == 7 ||
				$c1 == 7 || $c2 == 7 || $c3 == 7) {
					# Earn 3 points.
					$earn += 3;
					$result .= "$roll You have at least one 7! +3\n";
				}

				#   W A Y S   T O
				#   #      ###    ####  ######
				#   #     #   #  #      #
				#   #     #   #   ###   ####
				#   #     #   #      #  #
				#   ####   ###   ####   ######
				#  ----------------------------
				# If a row has all zeros or all nines.
				if (($a1 == 0 && $a2 == 0 && $a3 == 0) || ($b1 == 0 && $b2 == 0 && $b3 == 0) ||
				($c1 == 0 && $c2 == 0 && $c3 == 0)) {
					# Lose 10 points.
					$earn -= 10;
					$result .= "$roll You have a row of 0's! -10\n";
				}
				if (($a1 == 9 && $a2 == 9 && $a3 == 9) || ($b1 == 9 && $b2 == 9 && $b3 == 9) ||
				($c1 == 9 && $c2 == 9 && $c3 == 9)) {
					# Lose 10 points.
					$earn -= 10;
					$result .= "$roll You have a row of 9's! -10\n";
				}
				# If they have a diagonal of a bad number.
				if (($a1 == $b2 && $b2 == $c3) || ($a3 == $b2 && $b2 == $c1)) {
					# Diagonal of zeros.
					if ($b2 == 0) {
						# Lose 8 points.
						$earn -= 8;
						$result .= "$roll You got a diagonal of zeros! -8\n";
					}
					# Diagonal of sixes.
					if ($b2 == 6) {
						# Lose 30 points.
						$earn -= 30;
						$result .= "$roll You got a diagonal of 6's! -30\n";
					}
				}
				# If any row has all 6's.
				if (($a1 == 6 && $a1 == $a2 && $a1 == $a3) || ($b1 == 6 && $b1 == $b2 && $b1 == $b3) ||
				($c1 == 6 && $c1 == $c2 && $c1 == $c3)) {
					# Lose 50 points.
					$earn -= 50;
					$result .= "$roll You got a row of 6's! -50\n";
				}
				# See if there's at least one six.
				if ($a1 == 6 || $a2 == 6 || $a3 == 6 || $b1 == 6 || $b2 == 6 || $b3 == 6 ||
				$c1 == 6 || $c2 == 6 || $c3 == 6) {
					# Lose 3 points.
					$earn -= 3;
					$result .= "$roll You have at least one 6! -3\n";
				}

				# Update their points.
				if ($earn > 0) {
					$earn += $msg;
					&point_manager ($client,$listener,'+',$earn);
				}
				elsif ($earn < 0) {
					$earn -= $msg;
					my $neg = $earn;
					$neg =~ s/\-//g;
					&point_manager ($client,$listener,'-',$neg);
				}
				# Return their result.
				$result .= "\nYou earned a total of $earn. You now have "
					. $chaos->{_users}->{$client}->{points} . " points. Keep trying!";
				return $result;
			}
			else {
				return "You don't have $msg points to gamble, you only have "
					. $chaos->{_users}->{$client}->{points} . " points. Type "
					. "!pinfo for information on how to gain points.";
			}
		}
	}
	else {
		# If they don't even have 1 point, don't bother.
		if ($chaos->{_users}->{$client}->{points} <= 0) {
			return "Welcome to the Slot Machines!\n\n"
				. "You need more than 0 points to gamble here. Type !pinfo for "
				. "information about earning points.";
		}
		else {
			$chaos->{_users}->{$client}->{callback} = "slots";
			return "Welcome to the Slot Machines!\n\n"
				. "Your Points: " . $chaos->{_users}->{$client}->{points} . "\n\n"
				. "Type how many points you wish to gamble. :-)";
		}
	}
}

{
	Category => 'Points Earning',
	Description => 'Slot Machines',
	Usage => '!slots <points to bet>',
	Listener => 'All',
};