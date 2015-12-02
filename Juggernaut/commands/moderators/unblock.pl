#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !unblock
#    .::   ::.     Description // Unblock a user.
# ..:;;. ' .;;:..        Usage // !unblock <listener>-<username>
#    .  '''  .     Permissions // Moderator Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub unblock {
	my ($self,$client,$msg,$listener) = @_;

	my $reply;

	# Make sure this user is a Moderator or higher.
	if (isMod($client,$listener)) {
		my ($sl,$sn) = split(/\-/, $msg, 2);
		my $idiot = lc($sl) . "-" . lc($sn);
		my $file = uc($sl) . "-" . lc($sn);

		# See if they're not blocked.
		my ($isBlocked,$level) = isBlocked($sn,$sl);
		if ($level == 0) {
			return "$sn isn't blocked!";
		}
		elsif ($level == 2) {
			return "$sn is on the Blacklist, not a temporary block.";
		}
		elsif ($level == 3) {
			return "$sn is one of my own usernames and I won't talk to it.";
		}

		# Delete their file and block key.
		unlink ("./data/blocks/$file.txt");
		delete $chaos->{_data}->{blocks}->{$idiot};
		$reply = "I have unblocked $sn.";
	}
	else {
		$reply = "This command may only be used by a Moderator or higher.";
	}

	return $reply;
}

{
	Restrict => 'Moderator',
	Category => 'Moderator Commands',
	Description => 'Unblock a User',
	Usage => '!unblock <listener>-<username>',
	Listener => 'All',
};