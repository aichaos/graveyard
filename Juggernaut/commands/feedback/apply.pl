#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !apply
#    .::   ::.     Description // Apply for Admin Promotion.
# ..:;;. ' .;;:..        Usage // !apply
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub apply {
	my ($self,$client,$msg,$listener) = @_;

	# See if they've already applied.
	my $exists = 0;
	if (-e "./data/applications.txt" == 1) {
		open (EXIST, "./data/applications.txt");
		my @applications = <EXIST>;
		close (EXIST);

		chomp @applications;

		foreach my $line (@applications) {
			$line = lc($line);
			$line =~ s/ //g;

			$client = lc($client);
			$client =~ s/ //g;

			if ($exists == 0) {
				if ($line eq $client) {
					$exists = 1;
				}
			}
		}
	}

	# If this is a repeat application...
	if ($exists == 1) {
		# Remove 1 star from their record.
		&profile_get ($client,$listener);
		my $stars = $chaos->{_users}->{$client}->{stars};
		$stars--;
		&profile_send ($client,$listener,"stars",$stars);

		# Call the safe block sub.
		&system_block ($client,$listener,1,1);

		# If they've reached the -5 star limit.
		if ($stars <= -5) {
			return "You have left too many applications. Your star count is at -5.\n\n"
				. "You are now blocked permanently. Good-bye. :-(";
		}
		else {
			return "You have left more than one application. You have been docked -1 stars. "
				. "You now have $stars stars.\n\n"
				. "If you get down to -5 stars, you will be blocked permanently.";
		}
	}
	else {
		# Apply them.
		open (APPLY, ">>./data/applications.txt");
		print APPLY "$client\n";
		close (APPLY);

		return "I have left the application. It will be reviewed shortly.\n\n"
			. "Note: Spamming applications is one way to get banned from the bot.";
	}
}

{
	Category => 'Feedback',
	Description => 'Apply for Promotion',
	Usage => '!apply',
	Listener => 'All',
};