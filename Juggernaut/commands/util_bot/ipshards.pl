#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !ipshards
#    .::   ::.     Description // Convert an IP address into Shards ID Number.
# ..:;;. ' .;;:..        Usage // !ipshards <ip address>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub ipshards {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we have an address to convert.
	if ($msg =~ /(.*).(.*).(.*).(.*)/i) {
		# Split the IP address up.
		my @intervals = split(/\./, $msg);

		# Convert each one.
		my $final;
		foreach my $item (@intervals) {
			if ($item > 255) {
				return "No IP intervals can exceed 255.";
			}

			# Pad each interval with 3's until it is 3 digits long.
			if (length $item > 3) {
				return "That is an invalid IP address.";
			}
			elsif (length $item == 1) {
				$item = "33" . $item;
			}
			elsif (length $item == 2) {
				$item = "3" . $item;
			}

			# Multiply this interval by 2.
			$item = ($item * 2);

			$final .= $item;
		}

		$reply = "Shards ID Number: $final";
	}
	else {
		$reply = "Invalid format. Command usage is as follows:\n\n"
			. "!ipshards 127.0.0.1";
	}

	return $reply;
}

{
	Category => 'Bot Utilities',
	Description => 'Convert an IP to a Shards ID Number',
	Usage => '!ipshards <address>',
	Listener => 'All',
};