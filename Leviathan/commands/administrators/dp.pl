#      .   .               <Leviathan>
#     .:...::     Command Name // !dp
#    .::   ::.     Description // Change the MSN Display Picture.
# ..:;;. ' .;;:..        Usage // !dp [image]
#    .  '''  .     Permissions // Administrator Only.
#     :;,:,;:         Listener // MSN
#     :     :        Copyright // 2005 AiChaos Inc.

sub dp {
	my ($self,$client,$msg) = @_;

	# Must be an admin.
	return "This command may only be used by Administrators and higher!" unless &isAdmin($client);

	# Only for MSN.
	my ($listener,$name) = split(/\-/, $client, 2);
	return "This command is for MSN Messenger only." unless $listener eq 'MSN';

	# If a message is defined...
	if (length $msg > 0) {
		# Restrict the possibilities of the message.
		if ($msg =~ /\// || $msg =~ /:/) {
			return "Invalid message; I will not use that DP because of a "
				. "potential security risk.";
		}

		# Must be PNG.
		return "Only PNG images can be used as Display Pictures." unless $msg =~ /\.png$/i;

		# Exists?
		return "That Display Picture does not exist!" unless (-e "./data/msn/dp/$msg");

		# Finally... get it set.
		my $handle = $self->{Msn}->{Handle};
		$handle = lc($handle); $handle =~ s/ //g;
		my $msn = $chaos->{bots}->{$handle}->{client};

		$msn->setDisplayPicture ("./data/msn/dp/$msg");

		return "I have set my Display Picture. If it doesn't load right away, give it "
			. "a minute to download.";
	}
	else {
		# List the Display Pics.
		my @pics;
		opendir (DP, "./data/msn/dp") or return "The Display Pics folder could not be found!";
		foreach my $file (readdir(DP)) {
			next unless $file =~ /\.png$/i;
			push (@pics, $file);
		}
		closedir (DP);

		my $list = join ("\n", @pics);
		return ":: Display Pictures ::\n\n"
			. "Type \"$chaos->{config}->{commandchar}dp [filename]\" for an image listed below:\n\n"
			. "$list";
	}
}
{
	Restrict    => 'Administrators',
	Category    => 'Administrator Commands',
	Description => 'Change the MSN Display Picture.',
	Usage       => '!dp [image]',
	Listener    => 'MSN',
};