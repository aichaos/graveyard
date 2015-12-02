# COMMAND NAME:
#	IPSHARDS
# DESCRIPTION:
#	Convert an IP address to a Shards ID number.
# COMPATIBILITY:
#	FULLY COMPATIBLE

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
1;