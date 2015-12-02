# COMMAND NAME:
#	USERINFO
# DESCRIPTION:
#	Returns all information about a user.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub userinfo {
	# Get variables from the shift.
	my ($self,$client,$msg,$listener) = @_;

	# Make sure there's message content left.
	if ($msg) {
		# Split the listener and the username.
		my ($msgr,$who) = split(/\-/, $msg, 2);

		# Make sure it's formatted correctly.
		if ($msgr && $who) {
			# Make sure it's a valid username.
			if (-e "./clients/$msgr-$who.txt" == 1) {
				# Load their profile.
				&profile_get ($who,$msgr);

				# Send the info in a reply.
				$reply = ("User Info for $who:\n\n"
					. "Permission: $chaos->{users}->{$who}->{permission}\n"
					. "Message Count: $chaos->{users}->{$who}->{messages}\n"
					. "Name: $chaos->{users}->{$who}->{name}\n"
					. "Age: $chaos->{users}->{$who}->{age}\n"
					. "Gender: $chaos->{users}->{$who}->{sex}\n"
					. "Location: $chaos->{users}->{$who}->{location}\n"
					. "Fav. Color: $chaos->{users}->{$who}->{color}\n"
					. "Fav. Band: $chaos->{users}->{$who}->{band}\n"
					. "Fav. Book: $chaos->{users}->{$who}->{book}\n"
					. "Sexuality: $chaos->{users}->{$who}->{sexuality}\n"
					. "Job: $chaos->{users}->{$who}->{job}");
			}
			else {
				$reply = "User info for $who ($msgr) could not be located.";
			}
		}
		else {
			$reply = ("Your message is in an improper format.\n\n"
				. "!userinfo messenger-username");
		}
	}
	else {
		$reply = ("You must provide the messenger and username:\n\n"
			. "!userinfo messenger-username");
	}

	# Return the reply.
	return $reply;
}
1;