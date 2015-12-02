#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !donate
#    .::   ::.     Description // Donate points to another user.
# ..:;;. ' .;;:..        Usage // !donate <messenger-username> <points>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub donate {
	my ($self,$client,$msg,$listener) = @_;

	if (length $msg > 0) {
		# Get the listener and username.
		my ($to,$points) = split(/ /, $msg, 2);
		my ($mess,$user) = split(/\-/, $to, 2);

		$mess = uc($mess);
		$user = lc($user);

		# All must be defined.
		if (length $mess > 0 && length $user > 0 && length $points > 0) {
			# The points must be numeric.
			if ($points =~ /[^0-9]/i) {
				return "You can only donate a numeric number of points (remove any commas "
					. "or another symbols. You cannot donate decimals). From your message "
					. "I've deducted that \$points = \"$points\" - Make sure the username "
					. "you're donating to has no spaces. There should be only one space "
					. "between the recipient and the points. Example:\n\n"
					. "!donate msn-myname\@nowhere.net 25\n"
					. "!donate aim-AimUsername 10";
			}

			# Make sure they have enough points.
			if ($points > $chaos->{_users}->{$client}->{points}) {
				return "You don't have $points points to donate!";
			}

			# IRC users.
			if ($mess eq 'IRC' && $user !~ /^irc\_/i) {
				$user = 'IRC_' . $user;
			}

			# Make sure the user exists.
			if (-e "./clients/$mess\-$user\.txt") {
				# Update the points.

				# Remove from donor.
				&point_manager ($client,$listener,'-',$points);
				# Add to recipient.
				&point_manager ($user,$mess,'+',$points);

				return "I have given $points of your points to $user ($mess).";
			}
			else {
				return "The user you specified ($mess-$user) isn't in my records. If you "
					. "are sure the user you specified is correct, get them to send "
					. "me one non-command message so I can create a profile for them.";
			}
		}
		else {
			return "Missing a parameter. Examples of use:\n\n"
				. "!donate msn-myname\@nowhere.net 25\n"
				. "!donate aim-AimUsername 10";
		}
	}
	else {
		return "Usage:\n\n"
			. "!donate msn-myname\@nowhere.net 25\n"
			. "!donate aim-AimUsername 10";
	}
}

{
	Category => 'Points Earning',
	Description => 'Donate points to another user',
	Usage => '!donate <messenger-username> <points>',
	Listener => 'All',
};