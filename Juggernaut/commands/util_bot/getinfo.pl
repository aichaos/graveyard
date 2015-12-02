#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !getinfo
#    .::   ::.     Description // Get an AIM user's profile.
# ..:;;. ' .;;:..        Usage // !getinfo <aim screenname>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub getinfo {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we're on AIM.
	if ($listener eq "AIM") {
		# See if we have somebody to get info for.
		if (length $msg > 0) {
			my $sn = $self->screenname();
			$sn = lc($sn);
			$sn =~ s/ //g;

			if ($chaos->{_users}->{$client}->{callback} eq "getinfo") {
				# Get our ID number.
				my $id = $chaos->{_users}->{$client}->{_profile_get};

				# Load the info.
				open (INFO, "./data/temp/userinfo" . $id . ".html");
				my $profile = <INFO>;
				close (INFO);

				# Delete this temp file.
				unlink ("./data/temp/userinfo" . $id . ".html");

				# Delete this callback.
				delete $chaos->{_users}->{$client}->{callback};

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
				# Get info!
				$self->get_info ($msg);

				# Get an ID number.
				my $curr_id = $chaos->{$sn}->{profile_get};
				my $my_id = ($curr_id + 1);

				# Save our ID number.
				$chaos->{_users}->{$client}->{_profile_get} = $my_id;

				# Set the callback.
				$chaos->{_users}->{$client}->{callback} = "getinfo";

				return "User info for $msg has been retrieved. Type one non-command "
					. "message to retrieve it (Type 'next' to continue...)";
			}
		}
		else {
			return "You must specify a screenname to get a profile for!";
		}
	}
	elsif ($listener eq "MSN") {
		# Look for an open AIM bot.
		my $aimbot;
		foreach my $key (keys %{$chaos}) {
			if ($chaos->{$key}->{listener} eq "aim") {
				# We have an AIM bot!
				$aimbot = $key;
			}
		}

		# If we have an AIM bot open...
		if ($aimbot) {
			if ($chaos->{_users}->{$client}->{callback} eq "getinfo") {
				# Get our ID number.
				my $id = $chaos->{_users}->{$client}->{_profile_get};

				# Load the info.
				open (INFO, "./data/temp/userinfo" . $id . ".html") or return "Error in opening file.";
				my $profile = <INFO>;
				close (INFO);

				# Delete this temp file.
				unlink ("./data/temp/userinfo" . $id . ".html");

				# Delete this callback.
				delete $chaos->{_users}->{$client}->{callback};

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
				return "Profile Info:\n-----\n$profile";
			}
			else {
				# Get info!
				$chaos->{$aimbot}->{client}->get_info ($msg);

				# Get an ID number.
				my $curr_id = $chaos->{$aimbot}->{profile_get};
				my $my_id = ($curr_id + 1);

				# Save our ID number.
				$chaos->{_users}->{$client}->{_profile_get} = $my_id;

				# Set the callback.
				$chaos->{_users}->{$client}->{callback} = "getinfo";

				return "User info for $msg has been retrieved by AIM-$aimbot. Type one non-command "
					. "message to retrieve it (Type 'next' to continue...)";
			}
		}
		else {
			return "There was no available AIM bot to complete your request.";
		}
	}
	else {
		return "This command can only be used on AIM.";
	}
}

{
	Category => 'Bot Utilities',
	Description => 'Get an AIM User\'s Profile',
	Usage => '!getinfo <screenname>',
	Listener => 'AIM',
};