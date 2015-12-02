#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !dp
#    .::   ::.     Description // Update the MSN bot's display picture.
# ..:;;. ' .;;:..        Usage // !dp <file.png>
#    .  '''  .     Permissions // Admin Only
#     :;,:,;:         Listener // MSN
#     :     :        Copyright // 2004 Chaos AI Technology

sub dp {
	my ($self,$client,$msg,$listener) = @_;

	# This command is Admin Only.
	return "This command is Admin Only." if isAdmin($client,$listener) == 0;

	# This command only applies to MSN.
	return "This command is for MSN only." if $listener ne "MSN";

	# If they don't have a message, show a list of all the files.
	if (length $msg == 0) {
		my @list;
		# Open the directory.
		opendir (DP, "./data/msn/dp");
		foreach my $file (sort(grep(!/^\./, readdir(DP)))) {
			if ($file =~ /\.png$/i) {
				push (@list, $file);
			}
		}
		closedir (DP);

		# Send the reply.
		return "Display Pictures (in ./data/msn/dp):\n\n"
			. join ("\n", @list);
	}

	# Only allow display pictures to be set from the J'nautMSN Standard DP folder.
	if ($msg =~ /\//) {
		return "You can only use display pictures that are in the Juggernaut standard "
			. "MSN display pictures folder:\n\n"
			. "./data/msn/dp";
	}

	# Only allow PNG extension (only these are supported).
	if ($msg =~ /\.png$/i) {
		# See if this file exists.
		if (-e "./data/msn/dp/$msg" == 1) {
			# Get a reference to our handle.
			my $handle = $self->{Msn}->{Handle};
			$handle = lc($handle);
			$handle =~ s/ //g;

			# Set the display pic.
			$chaos->{$handle}->{client}->setDisplayPicture ("./data/msn/dp/$msg")
				or return "Error in setting the display picture: $!";

			return "Updated the display picture! If you don't yet see it, wait "
				. "a while and let it download...";
		}
		else {
			return "That file was nowhere to be found, $chaos->{_users}->{$client}->{name}.";
		}
	}
	else {
		return "Only the .PNG file extension is supported.";
	}

	return $reply;

}

{
	Restrict => 'Administrator',
	Category => 'Administrator Commands',
	Description => 'List/Set the Display Picture',
	Usage => '!dp [picture.png]',
	Listener => 'MSN',
};