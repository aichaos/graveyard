#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !call
#    .::   ::.     Description // Call a Moderator, Admin, or Master.
# ..:;;. ' .;;:..        Usage // !call [desired level]
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // AIM, MSN
#     :     :        Copyright // 2004 Chaos AI Technology

sub call {
	my ($self,$client,$msg,$listener) = @_;

	if ($listener ne "AIM" && $listener ne "MSN") {
		return "This command is for AIM and MSN only.";
	}

	# Are they flooding?
	if (exists $chaos->{_users}->{$client}->{_calltimeout}) {
		if (time < $chaos->{_users}->{$client}->{_calltimeout}) {
			return "You have used this command too often. Please leave 2 minutes (120 seconds) "
				. "between each use of this command.";
		}
		else {
			delete $chaos->{_users}->{$client}->{_calltimeout};
		}
	}

	my $level;
	my $who;

	# If they want a specific authority level...
	if (length $msg > 0) {
		print "Wanted specific level\n";
		($level,$who) = split(/ /, $msg, 2);
		$level = lc($level);
		$level =~ s/ //g;
		$who = lc($who);
		$who =~ s/ //g;
	}
	if (length $level == 0) {
		# Pick one.
		my $choose = int(rand(35)) + 1;

		if ($choose > 0 && $choose <= 9) {
			$level = 'moderator';
		}
		elsif ($choose >= 10 && $choose <= 30) {
			$level = 'administrator';
		}
		else {
			$level = 'botmaster';
		}
	}

	# Make sure this is a valid group.
	if ($level eq 'mod' || $level eq 'moderator' || $level eq 'admin' || $level eq 'administrator' || $level eq 'master' || $level eq 'botmaster') {
		# Find the file.
		my $file;
		$file = 'moderator.txt' if ($level eq 'mod' || $level eq 'moderator');
		$file = 'admin.txt' if ($level eq 'admin' || $level eq 'administrator');
		$file = 'master.txt' if ($level eq 'master' || $level eq 'botmaster');

		# Open this file.
		open (FILE, "./data/authority/$file");
		my @data = <FILE>;
		close (FILE);

		chomp @data;

		my @users;
		foreach my $line (@data) {
			my ($messenger,$username) = split(/\-/, $line, 2);
			$messenger = uc($messenger);
			$username = lc($username);
			$username =~ s/ //g;

			# If they wanted a specific person...
			if (length $who > 0) {
				if ($who eq $username && $listener eq $messenger) {
					push (@users, $username);
				}
			}
			else {
				# See if the messengers match.
				if ($listener eq $messenger) {
					push (@users, $username);
				}
			}
		}

		# Pick a random candidate.
		my $help = $users [ int(rand(scalar(@users))) ];

		if (length $who > 0 && length $help == 0) {
			return "The username $who ($level) could not be located. Make sure you "
				. "provided their authority level in your message, i.e.\n\n"
				. "!call admin [username]";
		}
		if (length $help == 0) {
			return "A $level could not be located for your messenger. Try narrowing "
				. "your search to a specific level, i.e.\n\n"
				. "!call admin";
		}

		# There's a 2-minute timeout between calls.
		$chaos->{_users}->{$client}->{_calltimeout} = time() + 120;

		# Handle this.
		if ($listener eq "AIM") {
			return "I have chosen " . uc($level) . " user $help. Click the link below to "
				. "send them an IM.\n\n"
				. "<a href=\"aim:goim?ScreenName=$help&Message=I+need+help.\">Click Here "
				. "to IM $help</a>\n\n"
				. "Note: $help may be offline.";
		}
		elsif ($listener eq "MSN") {
			my ($name,$domain) = split(/\@/, $help, 2);

			$self->sendmsg ("I am going to send a JOIN request for " . uc($level)
				. " $name\@... to enter this conversation.\n\n"
				. "If he does not join, he may be offline or may have blocked me.",
				Font => "Verdana",
				Color => "000000",
				Style => "Bold",
			);
			$self->invite ($help);
			print "CKS // Call Command:\n"
				. "\t" . "Username: $help (" . uc($level) . ")\n\n";

			return "<noreply>";
		}
	}
	else {
		return "That's not a valid authority group. Valid groups are:\n\n"
			. "Moderator, Administrator, Botmaster";
	}
}

{
	Category => 'Bot Utilities',
	Description => 'Call a Higher-Level User for Help',
	Usage => '!call [desired level [specific user]]',
	Listener => 'All',
};