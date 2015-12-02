#      .   .               <Leviathan>
#     .:...::     Command Name // !whatpulse
#    .::   ::.     Description // Get a WhatPulse user's profile.
# ..:;;. ' .;;:..        Usage // !whatpulse <username>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub whatpulse {
	my ($self,$client,$msg) = @_;

	# A username must be supplied.
	if (length $msg > 0) {
		my $wp = LWP::Simple::get "http://whatpulse.org/api/user.php?account=$msg";

		# Source must be defined and user must exist.
		if (length $wp == 0) {
			return "The WhatPulse API could not be contacted!";
		}
		if ($wp =~ /Invalid AccountName/i) {
			return "That user does not have a WhatPulse profile.";
		}

		# Array of lines.
		my @lines = split(/\n/, $wp);

		# Shift off the first line (contains User ID).
		my %pulse = (
			'UserID' => shift(@lines),
		);
		$pulse{'UserID'} =~ s/\# showing basic information about userid (.*?)/$1/ig;
		$pulse{'UserID'} =~ s/\s//g;

		# Go through the lines.
		foreach my $line (@lines) {
			next if length $line == 0;
			last if $line =~ /^X END/i;

			# Split the line up.
			my ($void,$var,$value) = split(/\s+/, $line, 3);
			$value =~ s/\s+$//ig;

			# Save it to the hash.
			$pulse{$var} = $value;
		}

		# Return the response.
		my $reply = ":: WhatPulse Profile ::\n\n"
			. "Username: $pulse{'AccountName'} (ID: $pulse{'UserID'})\n"
			. "Country: $pulse{'Country'}\n"
			. "Date Joined: $pulse{'DateJoined'}\n"
			. "Homepage: $pulse{'Homepage'}\n\n"
			. "Last Pulse: $pulse{'LastPulse'}\n"
			. "Total Pulses: $pulse{'Pulses'}\n"
			. "Total Key Count: $pulse{'TotalKeyCount'}\n"
			. "Av. Keys per Pulse: $pulse{'AvKeysPerPulse'}\n"
			. "Total Click Count: $pulse{'TotalMouseClicks'}\n"
			. "Av. Clicks per Pulse: $pulse{'AvClicksPerPulse'}\n\n"
			. "Average Keys per Second: $pulse{'AvKPS'}\n"
			. "Average Clicks per Second: $pulse{'AvCPS'}\n"
			. "Overall Rank: $pulse{'Rank'}";

		# If in a team...
		if (length $pulse{'TeamID'} > 0) {
			$reply .= "\n\n"
				. "Team Name: $pulse{'TeamName'} (ID: $pulse{'TeamID'})\n"
				. "Members: $pulse{'TeamMembers'}\n"
				. "Team Keys: $pulse{'TeamKeys'}\n"
				. "Team Clicks: $pulse{'TeamClicks'}\n"
				. "Description: $pulse{'TeamDescription'}\n"
				. "Date Formed: $pulse{'TeamDateFormed'}\n"
				. "Rank in Team: $pulse{'RankInTeam'}";
		}

		# Link to WhatPulse.org
		$reply .= "\n\n"
			. "WhatPulse ~ http://www.whatpulse.org/";

		# Return.
		return $reply;
	}
	else {
		return "You must provide a username when calling this command, i.e.\n\n"
			. "!whatpulse kirsle";
	}
}
{
	Category => 'Utilities',
	Description => 'Get a WhatPulse user\'s profile.',
	Usage => '!whatpulse <username>',
	Listener => 'All',
};