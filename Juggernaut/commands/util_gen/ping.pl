#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !ping
#    .::   ::.     Description // Ping a remote host for reachability.
# ..:;;. ' .;;:..        Usage // !ping <remote host>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub ping {
	my ($self,$client,$msg,$listener) = @_;

	# Check if a host is available to be pinged.
	if (length $msg > 0) {
		# Use Net::Ping to ping the site.
		use Net::Ping;

		my $p = Net::Ping->new();

		my $success = $p->ping ($msg) or return "$msg is NOT reachable.";
		return "$msg is reachable.";
	}
	else {
		return "Give me a host name to ping, i.e.\n\n"
			. "!ping sub.domain.com\n"
			. "!ping 127.0.0.1";
	}
}

{
	Category => 'General Utilities',
	Description => 'Ping a Web Host',
	Usage => '!ping <host>',
	Listener => 'All',
};