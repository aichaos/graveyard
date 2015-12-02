#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !staff
#    .::   ::.     Description // See the staff members!
# ..:;;. ' .;;:..        Usage // !staff
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub staff {
	my ($self,$client,$msg,$listener) = @_;

	# Load the staff members...
	my @masters;
	my @admins;
	my @mods;

	open (MODS, "./data/authority/moderator.txt");
	@mods = <MODS>;
	close (MODS);
	chomp @mods;

	open (ADMINS, "./data/authority/admin.txt");
	@admins = <ADMINS>;
	close (ADMINS);
	chomp @admins;

	open (MASTERS, "./data/authority/master.txt");
	@masters = <MASTERS>;
	close (MASTERS);
	chomp @masters;

	my %reply = (
		1 => '',
		2 => '',
		3 => '',
	);
	my ($lis,$name,$domain);

	foreach my $mod (@mods) {
		if (length $mod > 0) {
			($lis,$name) = split(/\-/, $mod, 2);
			if (uc($lis) eq "MSN") {
				($name,$domain) = split(/\@/, $name, 2);
				$name .= '@...';
			}
			$reply{1} .= "$name ($lis)\n";
		}
	}
	foreach my $admin (@admins) {
		if (length $admin > 0) {
			($lis,$name) = split(/\-/, $admin, 2);
			if (uc($lis) eq "MSN") {
				($name,$domain) = split(/\@/, $name, 2);
				$name .= '@...';
			}
			$reply{2} .= "$name ($lis)\n";
		}
	}
	foreach my $master (@masters) {
		if (length $master > 0) {
			($lis,$name) = split(/\-/, $master, 2);
			if (uc($lis) eq "MSN") {
				($name,$domain) = split(/\@/, $name, 2);
				$name .= '@...';
			}
			$reply{3} .= "$name ($lis)\n";
		}
	}

	# Return 3 replies.
	return ".: Moderators :.\n\n"
		. $reply{1} . '<:>'
		. ".: Administrators :.\n\n"
		. $reply{2} . '<:>'
		. ".: Botmasters :.\n\n"
		. $reply{3};
}

{
	Category => 'General',
	Description => 'Lists the Bot Staff Users',
	Usage => '!staff',
	Listener => 'All',
};