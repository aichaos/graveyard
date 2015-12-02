#              ::.                   .:.
#               .;;:  ..:::::::.  .,;:
#                 ii;,,::.....::,;;i:
#               .,;ii:          :ii;;:
#             .;, ,iii.         iii: .;,
#            ,;   ;iii.         iii;   :;.
# .         ,,   ,iii,          ;iii;   ,;
#  ::       i  :;iii;     ;.    .;iii;.  ,,      .:;
#   .,;,,,,;iiiiii;:     ,ii:     :;iiii;;i:::,,;:
#     .:,;iii;;;,.      ;iiii:      :,;iiiiii;,:
#          :;        .:,,:..:,,.        .:;..
#           i.                  .        ,:
#           :;.         ..:...          ,;
#            ,;.    .,;iiiiiiii;:.     ,,
#             .;,  :iiiii;;;;iiiii,  :;:
#                ,iii,:        .,ii;;.
#                ,ii,,,,:::::::,,,;i;
#                ;;.   ...:.:..    ;i
#                ;:                :;
#                .:                ..
#                 ,                :
#  Subroutine: isBlocked
# Description: Sees if the user is blocked or on the blacklist.

sub isBlocked {
	# Get variables from the shift.
	my ($client,$listener) = @_;

	# Admins, Masters, and White List users cannot be blocked.
	return 0 if isMaster ($client,$listener);
	return 0 if isAdmin ($client,$listener);
	return 0 if isSaved ($client,$listener);

	# Define a lowercases listener.
	my $ll = lc($listener);

	# Automatically block our own usernames.
	foreach my $clone (keys %{$chaos}) {
		next if $clone =~ /^hash\((.*?)\)$/i;
		if (exists $chaos->{$clone}->{client}) {
			if ($chaos->{$clone}->{listener} eq $ll) {
				if ($clone eq $client) {
					return (1,3);
				}
			}
		}
	}

	# Detect if they're a bot, by their username.
	if ($listener eq "AIM") {
		# An AIM bot would probably END with the word "bot"
		if ($client =~ /bot$/i) {
			# Return blocked.
			return (1,2);
		}
	}
	elsif ($listener eq "MSN") {
		# If the NAME part of the passport has "bot" in it.
		my ($name,$domain) = split(/\@/, $client, 2);
		if ($name =~ /bot/i) {
			# Return blocked.
			return (1,2);
		}
	}

	# Initially, they're not blocked.
	my $blocked = 0;
	my $level = 0;

	# This subroutine will return a level:
	# 1 = Temporary blocked
	# 2 = Blacklisted

	# See if they have a block key.
	$listener = lc($listener);
	my $block_key = ($listener . "-" . $client);
	if (exists $chaos->{_data}->{blocks}->{$block_key}) {
		# They're blocked.
		$blocked = 1;
		$level = 1;
	}
	else {
		# Perhaps we have a temporary block for them?
		# If so, load it up.
		if (-e "./data/blocks/$listener\-$client.txt" == 1) {
			# Open their blocked time.
			open (TIME, "./data/blocks/$listener\-$client.txt");
			my $time = <TIME>;
			close (TIME);
			chomp $time;

			# Set this time to their block key.
			$chaos->{_data}->{blocks}->{$block_key} = $time;

			# And, of course, they're blocked for now.
			$blocked = 1;
			$level = 1;

			# If their time has expired, they'll have better luck next time around.
		}
	}

	# If they don't have any temporary blocks... see if they're on the blacklist.
	if (-e "./data/blacklist.txt" == 1) {
		# If the blacklist exists, open it.
		open (LIST, "./data/blacklist.txt");
		my @list = <LIST>;
		close (LIST);

		chomp @list;

		# Go through each item on the list.
		foreach my $item (@list) {
			$item = lc($item);
			$item =~ s/ //g;

			# Convert stars (*) to wildcards.
			$item =~ s/\*/(.*)/ig;

			# If they compare...
			if ($item =~ /\*/) {
				if ($client =~ /^$item$/i) {
					# They're on the blacklist.
					$blocked = 1;
					$level = 2;
				}
			}
			else {
				if ($client eq $item) {
					# They're on the blacklist.
					$blocked = 1;
					$level = 2;
				}
			}
		}
	}

	# Return if they're blocked or not.
	return ($blocked,$level);
}
1;