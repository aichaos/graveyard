# COMMAND NAME:
#	ISEVIL
# DESCRIPTION:
#	Sees all the negative locks against a user.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub isevil {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we have somebody TO check.
	if ($msg) {
		my $blocked = isBlocked($msg);
		my $warner = isWarner($msg);

		# Send back the reply.
		if ($blocked == 0 && $warner == 0) {
			$reply = "The user [$msg] is neither blocked or on the warners list.";
		}
		elsif ($blocked == 1 && $warner == 0) {
			$reply = "$msg is on the blocked list, but not the warners list.";
		}
		elsif ($blocked == 0 && $warner == 1) {
			$reply = "$msg is not blocked, but they're on the warners list.";
		}
		elsif ($blocked == 1 && $warner == 1) {
			$reply = "$msg is both blocked and on the warners list.";
		}
		else {
			$reply = "$msg's status could not be determined due to a "
				. "program error. (Blocked:$blocked) (Warner:$warner)";
		}
	}
	else {
		$reply = "Improper usage. Correct usage is: !blocked [username]";
	}

	return $reply;
}
1;