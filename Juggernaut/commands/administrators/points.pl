#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !points
#    .::   ::.     Description // Point count manipulation.
# ..:;;. ' .;;:..        Usage // !points <lis.>-<name> <+|-|=><num>
#    .  '''  .     Permissions // Admin Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub points {
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
				goto dopoints;
			}

			if (isAdmin($to,$msgr) && (isAdmin($client,$listener) || isMaster($client,$listener))) {
				return "You cannot manipulate the star records of an Admin user.";
			}
			else {
				dopoints:
				if ($amount =~ /[^0-9]/) {
					return "You can only use numbers in this command.";
				}

				my $stars;
				$amount = 1 if not defined $amount;
				if ($type eq '+') {
					# Adding an amount.
					&point_manager ($to,$msgr,'+',$amount);

					return "I have given $amount points to $to.";
				}
				elsif ($type eq '-') {
					# Removing an amount.
					&point_manager ($to,$msgr,'-',$amount);

					return "I have taken $amount points from $to.";
				}
				elsif ($type eq '=') {
					# Setting equal an amount.
					&point_manager ($to,$msgr,'=',$amount);

					return "I have set $to\'s points to $amount.";
				}
				else {
					return "Invalid change type.";
				}
			}
		}
		else {
			return "Valid usage:\n\n"
				. "!points messenger-username (+|-|=)amount\n\n"
				. "!points aim-aimidiot -10\n"
				. "!points msn-my\@name.net +20\n";
		}
	}
	else {
		return "This command can only be used by Admins.";
	}
}

{
	Restrict => 'Administrator',
	Category => 'Administrator Commands',
	Description => 'Points Management',
	Usage => '!points <lis>-<name> <+|-|=><num>',
	Listener => 'All',
};