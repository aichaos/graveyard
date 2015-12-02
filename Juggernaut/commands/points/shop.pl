#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !shop
#    .::   ::.     Description // The Shop.
# ..:;;. ' .;;:..        Usage // !shop
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // MSN
#     :     :        Copyright // 2004 Chaos AI Technology

sub shop {
	my ($self,$client,$msg,$listener) = @_;

	$chaos->{_users}->{$client}->{callback} = 'shop';
	my $points = $chaos->{_users}->{$client}->{points};

	if (length $msg > 0) {
		if ($msg eq 'exit') {
			# Exit.
			delete $chaos->{_users}->{$client}->{callback};
			return "Alright, we're done with the shop.";
		}
		elsif ($msg eq '1') {
			# If they have enough points...
			if ($points >= 500) {
				&point_manager ($client,$listener,'-',500);

				my $stars = $chaos->{_users}->{$client}->{stars};
				$stars++;

				# Give them a star.
				&profile_send ($client,$listener,"stars",$stars);

				return "You have bought 1 star. You now have $stars stars.";
			}
			else {
				return "You need at least 500 points to buy a star.";
			}
		}
		elsif ($msg eq '2') {
			# If they have enough points...
			if ($points >= 2500) {
				&point_manager ($client,$listener,'-',2500);

				return "This is the secret to the Valley of the Green Glass "
					. "Doors. Remember this, next time it'll cost you 2500 "
					. "points again:\n\n"
					. "There are only words with double-letters. vaLLey of the "
					. "grEEn glaSS dOOrs";
			}
			else {
				return "You need at least 2500 points to buy this item.";
			}
		}
		else {
			return "Invalid item. Type !shop for a list of items.";
		}
	}
	else {
		return ".: The Shop :.\n\n"
			. "Type a number below that corresponds with the item you want:\n\n"
			. "1. Trade Points for Stars: 500 pts.\n"
			. "2. Answer to the Valley of the Green Glass Doors: 2500 pts.\n"
			. "More to come soon.\n\n"
			. ":: Related Commands ::\n"
			. "!info - See how many points you have\n"
			. "!donate - Donate points to another user\n\n"
			. "Type \"exit\" to exit the shop.";
	}
}

{
	Category => 'Points Earning',
	Description => 'The Shop',
	Usage => '!shop',
	Listener => 'All',
};