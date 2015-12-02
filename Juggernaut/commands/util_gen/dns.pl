#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !dns
#    .::   ::.     Description // Look up a site's DNS records.
# ..:;;. ' .;;:..        Usage // !dns <domain>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub dns {
	my ($self,$client,$msg,$listener) = @_;	

	# If we have a site to get...
	if (length $msg > 0) {
		use Net::DNS;

		my $res = Net::DNS::Resolver->new;
		my $query = $res->search ($msg);

		my $reply = "DNS Results for $msg:\n\n";

		if ($query) {
			foreach my $rr ($query->answer) {
				$reply .= $rr->type . " Record: " . $rr->address . "\n";
			}
		}
		else {
			return "Query failed: " . $res->errorstring;
		}

		return $reply;
	}
	else {
		return "Give me a domain to look up!\n\n"
			. "!dns host.example.com";
	}
}

{
	Category => 'General Utilities',
	Description => 'DNS Lookup',
	Usage => '!dns <domain>',
	Listener => 'All',
};