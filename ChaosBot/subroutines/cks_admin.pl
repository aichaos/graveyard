# Subroutine: cks_admin
# Checks if the user is a CKS Admin.

sub cks_admin {
	# Get needed variables from the shift.
	my ($client,$msg) = @_;

	# Get the local time.
	my $time = localtime();

	# Initially, they're not an admin.
	my $admin = 0;

	my @cks_admins = (
		"chaoscks",      # General administration.
		"guardchaos",    #
		"kirsle",        # Cerone Kirsle
		"aichaos",       #
		"azure2k6",      #
		"watereden",     #
		"shards2k6",     #
		"kirsle2",       #
		"cer2k6",        #
		"xenoandroid",   # William Hutchinson
		"nzenith87",     # Nathan Zenith
	);

	foreach my $username (@cks_admins) {
		if ($client eq $username) {
			$admin = 1;
		}
	}

	# Return if they're an admin.
	return $admin;
}
1;