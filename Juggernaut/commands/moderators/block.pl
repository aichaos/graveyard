#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !block
#    .::   ::.     Description // Block a user.
# ..:;;. ' .;;:..        Usage // !block <username> -> <time>
#    .  '''  .     Permissions // Moderator Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub block {
	my ($self,$client,$msg,$listener) = @_;

	my $reply;
	my $block_time;

	# Filter some things.
	$msg =~ s/\&lt\;/</ig;
	$msg =~ s/\&gt\;/>/ig;
	$msg =~ s/\&amp\;/\&/ig;
	$msg =~ s/\&quot\;/"/ig;
	$msg =~ s/\&apos\;/'/ig;

	# Make sure this user is a Moderator or higher.
	if (isMod($client,$listener) == 1) {
		# Block the user.
		my ($idiot,$time) = split (/\-\>/, $msg, 2);
		$idiot =~ s/ //g;
		$time =~ s/ //g;

		my ($sl,$sn) = split(/\-/, $idiot, 2);

		if (length $sl == 0) {
			return "Undefined listener.";
		}
		if (length $sn == 0) {
			return "Undefined username.";
		}

		# See if they're already temporarily blocked.
		my ($isBlocked,$level) = isBlocked(lc($sn),uc($sl));

		print "isBlocked: $isBlocked\nLevel: $level\n\n";
		if ($level == 1) {
			return "$sn already has been assigned a temporary block.";
		}
		elsif ($level == 2) {
			return "$sn is on the Blacklist and is banned permanently.";
		}
		elsif ($level == 3) {
			return "$sn is one of my own names and is banned to stop me from talking to myself.";
		}

		if ($time == 0) {
			&system_block ($sn,$sl,0);
			return "$sn has been banned indefinitely.";
		}
		else {
			&system_block ($sn,$sl,$time);
			return "$sn has been banned for $time hour(s).";
		}
	}
	else {
		return "This command may only be used by a Moderator or higher.";
	}
}

{
	Restrict => 'Moderator',
	Category => 'Moderator Commands',
	Description => 'Block a User',
	Usage => '!block <listener>-<username> -> <hours>',
	Listener => 'All',
};