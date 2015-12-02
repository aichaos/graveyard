#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !checkip
#    .::   ::.     Description // Get information from an IP address.
# ..:;;. ' .;;:..        Usage // !ip <address>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub checkip {
	my ($self,$client,$msg,$listener) = @_;

	# If there's an IP address...
	if (length $msg > 0) {
		# Check for a valid IP address.
		my $valid = 1;
		my @octets = split(/\./, $msg);
		foreach my $octet (@octets) {
			if ($octet =~ /[^\d]/) {
				$valid = 0;
				last;
			}
			if ($octet < 0 || $octet > 255) {
				$valid = 0;
				last;
			}
		}
		if (scalar @octets > 4 || scalar @octets < 4) {
			$valid = 0;
		}

		# If it's invalid...
		if ($valid == 0) {
			return "That is not a valid IP address. This may be any of the "
				. "following reasons:\n"
				. "- There were less than 4 octets\n"
				. "- There were more than 4 octets\n"
				. "- Any octet was less than 0\n"
				. "- Any octet was greater than 255\n"
				. "- Any octet was nonnumeric in value\n\n"
				. "This command currently only supports IPv4 addresses.";
		}

		# Use IP Modules.
		use Net::Whois::IP qw(whoisip_query); # For Whois Information.

		# Look up Whois information.
		my ($response,$replies) = whoisip_query ($msg);

		# See if we got a response.
		my $found = 0;
		my @items = (
			'OrgTechName',
			'TechEmail',
			'OrgAbuseEmail',
			'TechPhone',
			'NetRange',
			'Country',
			'StateProv',
			'City',
			'PostalCode',
		);
		foreach my $value (@items) {
			if (length $response->{$value} > 0) {
				$found = 1;
			}
		}

		# If there was no reply at all...
		if ($found == 0) {
			return "I could not find any information about the IP address "
				. "$msg. Some IP addresses have no information.";
		}

		return "IP Address: $msg\n\n"
			. ":: Internet Service Provider ::\n"
			. "Name: $response->{OrgTechName}\n"
			. "Tech Email: $response->{TechEmail}\n"
			. "Abuse Email: $response->{OrgAbuseEmail}\n"
			. "Phone: $response->{TechPhone}\n"
			. "Net Range: $response->{NetRange}\n\n"
			. ":: User Information ::\n"
			. "Country: $response->{Country}\n"
			. "State: $response->{StateProv}\n"
			. "City: $response->{City}\n"
			. "Zip: $response->{PostalCode}";
	}
	else {
		# Return the command's usage.
		return "Give me an IP address to look up, i.e.\n\n"
			. "!ip 207.73.160.23";
	}
}

{
	Category => 'General Utilities',
	Description => 'IP Address Lookup',
	Usage => '!checkip <address>',
	Listener => 'All',
};