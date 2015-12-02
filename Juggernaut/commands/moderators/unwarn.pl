#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !unwarn
#    .::   ::.     Description // Remove a user from the warners list.
# ..:;;. ' .;;:..        Usage // !unwarn <screenname>
#    .  '''  .     Permissions // Moderator Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub unwarn {
	my ($self,$client,$msg,$listener) = @_;

	my $reply;

	# Filter some things.
	$msg =~ s/\&lt\;/</ig;
	$msg =~ s/\&gt\;/>/ig;
	$msg =~ s/\&amp\;/\&/ig;
	$msg =~ s/\&quot\;/"/ig;
	$msg =~ s/\&apos\;/'/ig;

	# Make sure this user is a Moderator or higher.
	if (isMod($client,$listener) == 1) {
		if (length $msg == 0) {
			return "You didn't provide a username to unwarn.";
		}

		# Make sure the warners list exists.
		if (-e "./data/warners.txt" == 1) {
			# Format the warner's name.
			$msg = lc($msg);
			$msg =~ s/ //g;

			# See if this user is on the list.
			if (isWarner ($self,$msg,"AIM",1) == 0) {
				return "$msg is not on the warners list.";
			}

			# Remove this warner from the list.
			open (OLD, "./data/warners.txt");
			my @list = <OLD>;
			close (OLD);
			chomp @list;

			# Go through the list.
			my @warners;
			foreach my $item (@list) {
				$item = lc($item);
				$item =~ s/ //g;

				# If they match...
				if ($item eq $msg) {
					# Drop them.
				}
				else {
					# Keep them there.
					push @warners, $item;
				}
			}

			# Save the new list.
			my $final_list = join ("\n", @warners);
			open (NEW, ">./data/warners.txt");
			print NEW $final_list;
			close (NEW);

			# Return the response.
			return "I have removed $msg from the warners list.";
		}
		else {
			return "The warners list was nowhere to be found.";
		}
	}
	else {
		return "This command may only be used by a Moderator or higher.";
	}
}

{
	Restrict => 'Moderator',
	Category => 'Moderator Commands',
	Description => 'Remove a User from the AIM Warners List',
	Usage => '!unwarn <screenname>',
	Listener => 'All',
};