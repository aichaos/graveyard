#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !pulse
#    .::   ::.     Description // Get WhatPulse information about a user.
# ..:;;. ' .;;:..        Usage // !pulse <username>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub pulse {
	my ($self,$client,$msg,$listener) = @_;	

	# See if a username is available.
	if (length $msg > 0) {
		# Get the source.
		my $src = LWP::Simple::get "http://whatpulse.org/api/user.php?account=$msg"
			or return "Could not get URL via method LWP::Simple. The site may just be down.";

		# Go through the source.
		my @data = split(/\n/, $src);

		my %pulse;

		foreach my $line (@data) {
			# If this is a data line...
			if ($line =~ /^w/i) {
				my ($void,$type,$value) = split(/ /, $line, 3);

				$type = lc($type);

				$pulse{$type} = $value;
			}
		}

		# Return the response.
		my $reply = ":: WhatPulse Profile ::\n\n"
			. "Username: $pulse{accountname}\n"
			. "Country: $pulse{country}\n"
			. "Date Joined: $pulse{datejoined}\n"
			. "Homepage: $pulse{homepage}\n\n"
			. "Total Pulses: $pulse{pulses}\n"
			. "Last Pulse On: $pulse{lastpulse}\n\n"
			. "Total Keys: $pulse{totalkeycount}\n"
			. "Average Keys Per Pulse: $pulse{avkeysperpulse}\n"
			. "Average KPS: $pulse{avkps}\n"
			. "Total Clicks: $pulse{totalmouseclicks}\n"
			. "Average Clicks Per Pulse: $pulse{avclicksperpulse}\n"
			. "Average CPS: $pulse{avcps}\n\n"
			. "Overall Rank: $pulse{rank}";

		# If they're on a team...
		if (length $pulse{teamid} > 0) {
			$reply .= "\n\n"
				. "Team: $pulse{teamname} ($pulse{teamid})\n"
				. "Members: $pulse{teammembers}\n"
				. "Keys: $pulse{teamkeys}\n"
				. "Clicks: $pulse{teamclicks}\n"
				. "Description: $pulse{teamdescription}\n"
				. "Date Formed: $pulse{teamdateformed}\n"
				. "$msg\'s Rank In Team: $pulse{rankinteam}/$pulse{teammembers}";
		}

		# Return the reply.
		return $reply;
	}
	else {
		return "You must give me a WhatPulse username to check, i.e.\n\n"
			. "!pulse Kirsle";
	}

}

{
	Category => 'General Utilities',
	Description => 'WhatPulse Profile Lookup',
	Usage => '!pulse <username>',
	Listener => 'All',
};