#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !warn
#    .::   ::.     Description // Add a user to the warners list.
# ..:;;. ' .;;:..        Usage // !warn <screenname>
#    .  '''  .     Permissions // Moderator Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub warn {
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
			return "You didn't give me a username to add to the warners list.";
		}

		# See if they're not already on the list.
		if (isWarner ($self,$msg,"AIM",1)) {
			return "$msg is already in the warners list.";
		}

		# Add the user to the warners list.
		if (-e "./data/warners.txt" == 1) {
			open (LIST, ">>./data/warners.txt");
			print LIST "\n$msg";
			close (LIST);
		}
		else {
			open (LIST, ">./data/warners.txt");
			print LIST "$msg";
			close (LIST);
		}

		return "I have added $msg to the warners list.";
	}
	else {
		$reply = "This command may only be used by a Moderator or higher.";
	}

	return $reply;
}

{
	Restrict => 'Moderator',
	Category => 'Moderator Commands',
	Description => 'Add a User to the AIM Warners List',
	Usage => '!warn <screenname>',
	Listener => 'All',
};