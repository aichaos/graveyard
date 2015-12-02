#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !demote
#    .::   ::.     Description // Demote a user down one level.
# ..:;;. ' .;;:..        Usage // !demote <listener>-<username>
#    .  '''  .     Permissions // Admin Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub demote {
	my ($self,$client,$msg,$listener) = @_;

	# Get the listener and name.
	my ($lis,$name) = split(/\-/, $msg, 2);
	$lis = uc($lis);
	$name = lc($name);
	$name =~ s/ //g;

	if (isAdmin ($client,$listener)) {
		if ($lis && $name) {
			my $file;

			# If they can't be demoted...
			if (isMaster($name,$lis)) {
				return "$name is a Botmaster and is ineligible for demotion.";
			}

			# If they're already at the bottom...
			if (isAdmin($name,$lis) == 0 && isMod($name,$lis) == 0) {
				return "$name cannot be demoted any further than Client.";
			}

			# If they're an Admin, demote to Moderator.
			if (isAdmin($name,$lis)) {
				# Set the data.
				$file = "admin.txt";
			}
			# Else, demote them to user.
			else {
				# Set the data.
				$file = "moderator.txt";
			}

			# If they are both Admins...
			if (isAdmin($client,$listener) && isMaster($client,$listener) == 0 && isAdmin($name,$lis)) {
				return "You cannot demote a fellow Admin user.";
			}

			# Demote them.
			open (FILE, "./data/authority/$file");
			my @data = <FILE>;
			close (FILE);

			chomp @data;

			my $count = 0;
			my $final;

			foreach my $line (@data) {
				my ($alis,$asn) = split(/\-/, $line, 2);
				$alis = uc($alis);
				$alis =~ s/ //g;
				$asn = lc($asn);
				$asn =~ s/ //g;

				if ($lis eq $alis && $name eq $asn) {
					# Ignore it.
				}
				else {
					if ($count == 0) {
						$final = $line;
						$count++;
					}
					else {
						$final .= "\n$line";
					}
				}
			}

			open (NEW, ">./data/authority/$file");
			print NEW $final;
			close (NEW);

			return "I have demoted $name.";
		}
		else {
			return "Proper usage is:\n\n"
				. "!demote listener-username";
		}
	}
	else {
		return "This command may only be used by Admins or Masters.";
	}

	return $reply;
}

{
	Restrict => 'Administrator',
	Category => 'Administrator Commands',
	Description => 'Demote a User',
	Usage => '!demote <listener>-<username>',
	Listener => 'All',
};