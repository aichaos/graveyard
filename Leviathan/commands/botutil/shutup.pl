#      .   .               <Leviathan>
#     .:...::     Command Name // !shutup
#    .::   ::.     Description // Makes the bot shut up for the entire conversation.
# ..:;;. ' .;;:..        Usage // !shutup
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // MSN
#     :     :        Copyright // 2005 AiChaos Inc.

sub shutup {
	my ($self,$client,$msg) = @_;

	my ($listener,$nick) = split(/\-/, $client, 2);

	# Only applies to MSN.
	if ($listener eq 'MSN') {
		# Get the socket.
		my $sock = $self->getID;

		# Get our handle.
		my $sn = $self->{Msn}->{Handle};
		$sn = lc($sn);
		$sn =~ s/ //g;

		if (!exists $chaos->{bots}->{$sn}->{_shutup}->{$sock}) {
			# Create the shut up key.
			$chaos->{bots}->{$sn}->{_shutup}->{$sock} = 1;

			return "Alright, I will not talk in this conversation. Use !shutup again to "
				. "make me talk.";
		}
		else {
			# Delete the key.
			delete $chaos->{bots}->{$sn}->{_shutup}->{$sock};

			return "Thanks, I'll chat here again. :-)";
		}
	}
	else {
		return "This command only applies to MSN.";
	}
}

{
	Category => 'Bot Utilities',
	Description => 'Make me shut up for the entire conversation.',
	Usage => '!shutup',
	Listener => 'MSN',
};