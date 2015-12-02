#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !lyst
#    .::   ::.     Description // Update your bot's CKS Lyst information.
# ..:;;. ' .;;:..        Usage // !lyst <variable> <value>
#    .  '''  .     Permissions // Master
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub lyst {
	# Get variables from the shift.
	my ($self,$client,$msg,$listener) = @_;

	# This command is Master Only.
	if (isMaster($client,$listener) == 0) {
		return "This command is Master Only.";
	}

	# Only applies to AIM and MSN bots at the moment.
	if ($listener ne "AIM" && $listener ne "MSN") {
		return "Bot lyst information can only be used on AIM and MSN.";
	}

	my %cks;
	# CKS Server Details.
	$cks{server} = "chaos.kirsle.net";
	$cks{uri} = "/lyst.pl";

	# CKS Error Messages.
	$cks{noreply} = "No response from server!";

	$cks{server} = "http://" . $cks{server};

	$cks{file} = $cks{server} . $cks{uri};

	# This command is Master Only.
	if (isMaster($client,$listener)) {
		# Go through the actions.
		my ($type,$text) = split(/ /, $msg, 2);
		$type = lc($type);

		my $sn;
		$sn = $self->screenname() if $listener eq "AIM";
		$sn = $self->{Msn}->{Handle} if $listener eq "MSN";
		$sn = lc($sn);
		$sn =~ s/ //g;

		return "Unknown error with screenname." if $sn eq "";

		if ($type eq "remove") {
			# Remove from the list.
			$cks{reply} = get "$cks{file}?sn=$sn&type=remove&text=$sn" or return $cks{noreply};

			print $cks{reply};

			return "I have sent the request to be removed.";
		}
		elsif ($type eq "screenname") {
			# Sending the screenname.

			$cks{reply} = get "$cks{file}?sn=$sn&type=screenname&text=$sn" or return $cks{noreply};
			if ($cks{reply} =~ /\[0\]/) {
				return "Unregistered screenname. To register:\n\n"
					. "!lyst screenname";
			}

			print $cks{reply};

			return "I have sent my screenname to the bot lyst.";
		}
		else {
			# Our array of valid items.
			my @vars = (
				"author",
				"name",
				"title",
				"description",
				"website",
				"template",
				"language",
			);
			foreach my $item (@vars) {
				if ($type eq $item) {
					# Send this information.
					$cks{reply} = get "$cks{file}?sn=$sn&type=$type&text=$text";

					print $cks{reply};

					if ($cks{reply} =~ /\[0\]/) {
						return "Unregistered screenname. To register:\n\n"
							. "!lyst screenname";
					}

					return "I have sent the information.\n\n$type=$text";
				}
			}

			return "Invalid Lyst Item. Items are:\n\n"
				. "screenname -- Register your screenname\n"
				. "remove -- Remove your screenname\n\n"
				. "author [your name]\n"
				. "name [bots name]\n"
				. "title [short description]\n"
				. "description [long description]\n"
				. "website [website url]\n"
				. "template [template used]\n"
				. "language [language programmed in]";
		}
	}
	else {
		return "Only the bot's master can set my lyst data.";
	}
}

{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Update your CKS Lysting',
	Usage => '!lyst <variable> <value>',
	Listener => 'All',
};