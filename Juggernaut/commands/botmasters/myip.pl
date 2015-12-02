#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !myip
#    .::   ::.     Description // Get the IP of the bot's host computer.
# ..:;;. ' .;;:..        Usage // !myip
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub myip {
	my ($self,$client,$msg,$listener) = @_;

	# Our access level ("Admin", "Master", or 0 for none)
	my $access = "Master";

	# If they can't use this...
	print "\$access: $access\n";
	if (length $access > 1) {
		print "\$access != 0\n";
		if ($access eq "Admin") {
			print "\$access = Admin\n";
			if (isAdmin($client,$listener) == 0) {
				return "This command is Admin Only.";
			}
		}
		elsif ($access eq "Master") {
			print "\$access = Master\n";
			if (isMaster($client,$listener) == 0) {
				return "This command is Master Only.";
			}
		}
		else {
			return "Unknown access type: $access";
		}
	}

	# Our service for gathering the IP.
	my $link = 'http://chaos.kirsle.net/ip.pl';

	# Filter the * into a wildcard.
	$text =~ s/\*/(.*)/ig;

	# Get the URL.
	my $src = get $link or return "Could not access IP service.";

	# See if we can get the IP.
	my $ip;
	if ($src =~ /your ip address is: \[(.*)\]/i) {
		$ip = $1;

		return "The host computer's IP Address is: $ip";
	}
	else {
		return "I could not find the IP address on the page $link";
	}
}

{
	Restriction => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Get Localhost IP Address',
	Usage => '!myip',
	Listener => 'All',
};