#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !promote
#    .::   ::.     Description // Promote a user up one level.
# ..:;;. ' .;;:..        Usage // !promote <listener>-<username>
#    .  '''  .     Permissions // Admin Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub promote {
	my ($self,$client,$msg,$listener) = @_;

	# Get the listener and name.
	my ($lis,$name) = split(/\-/, $msg, 2);
	$lis = uc($lis);
	$name = lc($name);
	$name =~ s/ //g;

	if (isAdmin ($client,$listener)) {
		if ($lis && $name) {
			# Botmasters can't be promoted.
			if (isMaster($name,$lis)) {
				return "$name is a Botmaster and is ineligible for promotion.";
			}

			# Can't be promoted above Admin.
			if (isAdmin($name,$lis)) {
				return "Admin is the highest level a user can be promoted.";
			}

			# If the user is a Moderator, promote them to Admin.
			if (isMod($name,$lis)) {
				# Promote them.
				open (ADMIN, ">>./data/authority/admin.txt");
				print ADMIN "\n$lis" . '-' . "$name";
				close (ADMIN);

				return "I have promoted $name to Admin.";
			}
			# Else, promote them to moderator.
			else {
				# Promote them.
				open (MOD, ">>./data/authority/moderator.txt");
				print MOD "\n$lis" . '-' . "$name";
				close (MOD);

				return "I have promoted $name to Moderator.";
			}
		}
		else {
			return "Proper usage is:\n\n"
				. "!promote listener-username";
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
	Description => 'Promote a User',
	Usage => '!promote <listener>-<username>',
	Listener => 'All',
};