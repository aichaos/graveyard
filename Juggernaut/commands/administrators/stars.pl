#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !stars
#    .::   ::.     Description // Star count manipulation.
# ..:;;. ' .;;:..        Usage // !stars <lis.>-<name> <+|-|=><number>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub stars {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure they're an Admin.
	if (isAdmin($client,$listener)) {
		# Get the information.
		my ($who,$info) = split(/ /, $msg, 2);
		my ($msgr,$to) = split(/\-/, $who, 2);
		my ($type,$amount) = split(//, $info, 2);

		$msgr = uc($msgr);
		$to = lc($to);
		$amount =~ s/ //g;

		# Make sure they're not doing this to a fellow Admin.
		if ($who) {
			if (isMaster($client,$listener)) {
				goto dostars;
			}

			if (isAdmin($to,$msgr) && (isAdmin($client,$listener) || isMaster($client,$listener))) {
				return "You cannot manipulate the star records of an Admin user.";
			}
			else {
				dostars:
				if ($amount =~ /[^0-9]/) {
					return "You can only use numbers in this command.";
				}

				my $stars;
				$amount = 1 if not defined $amount;
				if ($type eq '+') {
					# Adding an amount.
					&profile_get ($to,$msgr);
					$stars = $chaos->{_users}->{$to}->{stars};
					$stars = $stars + $amount;
					&profile_send ($to,$msgr,"stars",$stars);

					return "I have added $amount to $to\'s star count.";
				}
				elsif ($type eq '-') {
					# Removing an amount.
					&profile_get ($to,$msgr);
					$stars = $chaos->{_users}->{$to}->{stars};
					$stars = $stars - $amount;
					&profile_send ($to,$msgr,"stars",$stars);

					return "I have removed $amount from $to\'s star count.";
				}
				elsif ($type eq '=') {
					# Setting equal an amount.
					&profile_get ($to,$msgr);
					$stars = $chaos->{_users}->{$to}->{stars};
					$stars = $amount;
					&profile_send ($to,$msgr,"stars",$stars);

					return "I have set $to\'s star count to $amount.";
				}
				else {
					return "Invalid change type.";
				}
			}
		}
		else {
			return "Valid usage:\n\n"
				. "!stars messenger-username (+|-|=)amount\n\n"
				. "!stars aim-aimidiot -10\n"
				. "!stars msn-my\@name.net +20\n";
		}
	}
	else {
		return "This command can only be used by Admins.";
	}
}

{
	Restrict => 'Administrator',
	Category => 'Administrator Commands',
	Description => 'Stars Management',
	Usage => '!stars <lis>-<username> <+|-|=><num>',
	Listener => 'All',
};