# COMMAND NAME:
#	PROMOTE
# DESCRIPTION:
#	Promote a user.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub promote {
	my ($self,$client,$msg,$listener) = @_;

	# This is to promote a user.
	$reply = "";

	my ($who, $what_to) = split(/ /, $msg, 2);

	# Make sure this person CAN use this command...
	if (isMaster($client,$listener)) {
		# They can. Let's get some information on who they're
		# looking up.
		my ($messenger,$who) = split(/\-/, $who);
		$messenger = uc($messenger);

		# Make sure the permission is valid.
		if ($what_to eq "Client" ||$what_to eq "Gifted" || $what_to eq "Keeper" ||
		$what_to eq "Moderator" || $what_to eq "Super Moderator" ||
		$what_to eq "Admin" || $what_to eq "Super Admin") {
			# Promote the user if they exist.
			if (-e "./clients/$messenger-$who.txt" == 1) {
				&profile_send ($who,$messenger,"permission",$what_to);

				$reply = "I have promoted $who to $what_to.";
			}
			else {
				$reply = "That user could not be located.";
			}
		}
		elsif ($what_to eq "Master") {
			$reply = "A bot can have only one Master.";
		}
	}

	if ($reply eq "") {
		$reply = "This command can only be used by Masters.";
	}

	# Return the reply.
	return $reply;
}
1;