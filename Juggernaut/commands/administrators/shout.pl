#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !shout
#    .::   ::.     Description // Send a message to all MSN conversations.
# ..:;;. ' .;;:..        Usage // !shout <message>:-:<color>
#    .  '''  .     Permissions // Admin Only
#     :;,:,;:         Listener // MSN
#     :     :        Copyright // 2004 Chaos AI Technology

sub shout {
	my ($self,$client,$msg,$listener) = @_;

	# This command is for MSN.
	return "This command is for MSN only." if $listener ne "MSN";

	# This command is Admin Only.
	return "This command is Admin Only." if isAdmin($client,$listener) == 0;

	# There has to be a message.
	if (length $msg > 0) {
		# See if they have a color.
		my ($send,$color) = split(/:\-:/, $msg, 2);

		my $sn = $self->{Msn}->{Handle};
		$sn = lc($sn);
		$sn =~ s/ //g;

		$color = lc($color);
		$color =~ s/ //g;

		$color = "red" if length $color == 0;

		# We only support a few basic colors.
		my %allowed = (
			red     => '0000FF',
			blue    => 'FF0000',
			green   => '009900',
			fuchsia => 'FF00FF',
			yellow  => '00FFFF',
			cyan    => 'FFFF00',
			black   => '000000',
			silver  => 'CCCCCC',
			gray    => '999999',
		);

		my $okay = 0;
		foreach my $key (%allowed) {
			if ($color eq $key) {
				$okay = 1;
			}
		}

		# Or if it was a color code...
		if (length $color == 6 && $color !~ /[^0-9A-Fa-f]/i) {
			$color = uc($color);
			$okay = 1;
		}

		# If the color is okay...
		if ($okay == 1) {
			if (exists $allowed{$color}) {
				$color = $allowed{$color};
			}

			print "Color: $color\n";

			my $msn = $chaos->{$sn}->{client};

			my $count = 0;
			# Get the socks and send the message.
			my $socks = $msn->getConvoList ();
			foreach my $id (keys %{$socks}) {
				my $convo = $msn->getConvo ($id);

				$convo->sendmsg ("Broadcast: $send",
					Font => "Courier New",
					Color => "$color",
					Style => "Bold",
				);
				$count++;
			}

			return "I have sent the message to $count socket." if $count == 1;
			return "I have sent the message to $count sockets.";
		}
		else {
			return "Invalid color name:\n"
				. "!shout <lt>message<gt>[:-:color]\n"
				. "You can omit the color to make it the default, red.\n\n"
				. "Colors supported are:\n"
				. "red blue green fuchsia yellow cyan black silver gray";
		}
	}
	else {
		return "You need to give a message to send:\n\n"
			. "!shout <lt>message<gt>[:-:color]\n\n"
			. "Supported Colors:\n"
			. "red blue green fuchsia yellow cyan black silver gray";
	}
}

{
	Restrict => 'Administrator',
	Category => 'Administrator Commands',
	Description => 'Broadcast Message to All Sockets',
	Usage => '!shout <message>:-: <color>',
	Listener => 'MSN',
};