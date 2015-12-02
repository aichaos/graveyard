#      .   .               <Leviathan>
#     .:...::     Command Name // !getinfo
#    .::   ::.     Description // Get an AIM user's profile.
# ..:;;. ' .;;:..        Usage // !getinfo <screenname>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub getinfo {
	my ($self,$client,$msg) = @_;

	my ($listener,$nick) = split(/\-/, $client, 2);

	# Must define a username.
	return "You must define a screenname when calling this command!" unless length $msg > 0;

	# On AIM, directly get the info.
	if ($listener eq "AIM") {
		my $sn = $self->screenname();
		$sn = lc($sn);
		$sn =~ s/ //g;

		# If we're in the callback...
		if (exists $chaos->{clients}->{$client}->{_profile_get}) {
			my $id = $chaos->{clients}->{$client}->{_profile_get};
			delete $chaos->{clients}->{$client}->{_profile_get};

			# Load the info.
			open (INFO, "./data/temp/userinfo" . $id . ".html");
			my $profile = <INFO>;
			close (INFO);

			# Delete this temp file.
			unlink ("./data/temp/userinfo" . $id . ".html");

			# Delete this callback.
			delete $chaos->{clients}->{$client}->{callback};

			# Return the info.
			if ($profile eq '<hr>' || $profile eq ' ' || $profile eq '') {
				return "Buddy info could not be retrieved. This may be "
					. "because this user is offline or may be an "
					. "AOL or AIM users. It is also possible that "
					. "this user might not have created a profile.";
			}
			else {
				return $profile;
			}
		}
		else {
			# Get an ID number.
			my $curid = $chaos->{bots}->{$sn}->{_profile_get} || 0;
			my $id = $curid + 1;
			$chaos->{clients}->{$client}->{_profile_get} = $id;
			$chaos->{bots}->{$sn}->{_profile_get} = $curid;

			# Get the info.
			$self->get_info ($msg);

			# Set the callback.
			$chaos->{clients}->{$client}->{callback} = 'getinfo';

			return "User info has been retrieved. Type one non-command message "
				. "to retrieve it (type 'next' to continue).";
		}
	}
	else {
		# Look for an available AIM bot.
		my $aimbot = '';
		foreach my $key (keys %{$chaos->{bots}}) {
			if ($chaos->{bots}->{$key}->{listener} =~ /^aim$/i) {
				# We got one!
				$aimbot = $key;
			}
		}

		# If we have an AIM bot...
		if (length $aimbot > 0) {
			# If we're in the callback...
			if (exists $chaos->{clients}->{$client}->{_profile_get}) {
				my $id = $chaos->{clients}->{$client}->{_profile_get};
				delete $chaos->{clients}->{$client}->{_profile_get};

				# Load the info.
				open (INFO, "./data/temp/userinfo" . $id . ".html");
				my $profile = <INFO>;
				close (INFO);

				# Delete this temp file.
				unlink ("./data/temp/userinfo" . $id . ".html");

				# Delete this callback.
				delete $chaos->{clients}->{$client}->{callback};

				# Filter the info for HTML.
				$profile =~ s/<hr>/\n--------\n/ig;
				$profile =~ s/<br>/\n/ig;
				$profile =~ s/<(.|\n)+?>//g;
				$profile =~ s/\&quot\;/"/ig;
				$profile =~ s/\&apos\;/"/ig;
				$profile =~ s/\&lt\;/</ig;
				$profile =~ s/\&gt\;/>/ig;
				$profile =~ s/\&amp\;/\&/ig;

				# Return the info.
				if ($profile eq '<hr>' || $profile eq ' ' || $profile eq '') {
					return "Buddy info could not be retrieved. This may be "
						. "because this user is offline or may be an "
						. "AOL or AIM users. It is also possible that "
						. "this user might not have created a profile.";
				}
				else {
					return $profile;
				}
			}
			else {
				# Get an ID number.
				my $curid = $chaos->{bots}->{$aimbot}->{_profile_get} || 0;
				my $id = $curid + 1;
				$chaos->{clients}->{$client}->{_profile_get} = $id;
				$chaos->{bots}->{$aimbot}->{_profile_get} = $curid;

				# Get the info.
				$chaos->{bots}->{$aimbot}->{client}->get_info ($msg);

				# Set the callback.
				$chaos->{clients}->{$client}->{callback} = 'getinfo';

				return "User info has been retrieved by AIM bot $aimbot. Type one non-command message "
					. "to retrieve it (type 'next' to continue).";
			}
		}
		else {
			return "I don't have an AIM bot available to complete the request.";
		}
	}
}

{
	Category => 'Bot Utilities',
	Description => 'Get an AIM screenname\'s profile.',
	Usage => '!getinfo <screenname>',
	Listener => 'All',
};