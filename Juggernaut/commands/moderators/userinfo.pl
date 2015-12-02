#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !userinfo
#    .::   ::.     Description // Get information about a user.
# ..:;;. ' .;;:..        Usage // !userinfo <listener>-<username>
#    .  '''  .     Permissions // Moderator Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub userinfo {
	my ($self,$client,$msg,$listener) = @_;

	# This command is  Moderator Only.
	if (isMod($client,$listener)) {
		# Get who we're looking for from the message.
		my ($lis,$name) = split(/\-/, $msg, 2);
		$lis = uc($lis);
		$lis =~ s/ //g;
		$name = lc($name);
		$name =~ s/ //g;

		return "Missing or malformed listener name." if length $lis != 3;
		return "Missing or malformed user name." if length $name == 0;

		# Has to exist.
		return "That user is not in my database." unless -e "./clients/$lis\-$name\.txt";

		# Mask the userinfo of the Master.
		if (isMaster($lis,$name)) {
			return "$name is the botmaster and their information is masked and "
				. "cannot be displayed to Admins.";
		}
		else {
			# Load this user's profile.
			&profile_get ($name,$lis);

			# Get if they're blocked or a warner.
			my ($blocked,$level) = isBlocked($name,$lis);
			my $warner = isWarner ($self,$name,$lis);

			$blocked = 'true' if $blocked == 1;
			$warner = 'true' if $warner == 1;
			$blocked = 'false' if $blocked == 0;
			$warner = 'false' if $warner == 0;

			my $reason;
			if (not defined $level) {
				$reason = "Not blocked.";
			}
			elsif ($level == 1) {
				my $key = lc($lis) . '-' . lc($name);
				my $expire = $chaos->{_data}->{blocks}->{$key};
				my $block_left = $expire - time;
				my $block_hours = int($block_left / (60*60));
				$reason = "Temporary Ban: Approximately $block_hours left.";
			}
			elsif ($level == 2) {
				$reason = "Permanent Ban: Blacklisted.";
			}
			elsif ($level == 3) {
				$reason = "Permanent Ban: Loophole Connection.";
			}
			else {
				$reason = "Undefined Reason";
			}

			# Start the reply.
			my $reply = "User Info for $name\n\n"
				. "Name: " . $chaos->{_users}->{$name}->{name} . "\n"
				. "Age: " . $chaos->{_users}->{$name}->{age} . "\n"
				. "Sex: " . $chaos->{_users}->{$name}->{sex} . "\n"
				. "Location: " . $chaos->{_users}->{$name}->{location} . "\n"
				. "Points: " . $chaos->{_users}->{$name}->{points} . "\n"
				. "Stars: " . $chaos->{_users}->{$name}->{stars} . "\n"
				. "Time Zone: " . $chaos->{_users}->{$name}->{time} . "\n"
				. "Personality: " . $chaos->{_users}->{$name}->{personality} . "\n"
				. "Color: " . $chaos->{_users}->{$name}->{color} . "\n"
				. "Book: " . $chaos->{_users}->{$name}->{book} . "\n"
				. "Band: " . $chaos->{_users}->{$name}->{band} . "\n"
				. "Job: " . $chaos->{_users}->{$name}->{job} . "\n"
				. "Spouse: " . $chaos->{_users}->{$name}->{spouse} . "\n"
				. "Sexuality: " . $chaos->{_users}->{$name}->{sexuality} . "\n"
				. "Friends: " . $chaos->{_users}->{$name}->{friends} . "\n"
				. "Website: " . $chaos->{_users}->{$name}->{website} . "\n\n"
				. "Is Blocked: $blocked - $reason\n"
				. "Is Warner: $warner";

			# Return the reply.
			return $reply;
		}
	}
	else {
		return "This command may only be used by Moderators.";
	}
}

{
	Restriction => 'Moderator',
	Category => 'Moderator Commands',
	Description => 'Get a User\'s Profile Info',
	Usage => '!userinfo <listener>-<username>',
	Listener => 'All',
};