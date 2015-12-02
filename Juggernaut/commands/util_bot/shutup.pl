#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !shutup
#    .::   ::.     Description // Makes the MSN bot not reply in current convo (treats it like the chat)
# ..:;;. ' .;;:..        Usage // !shutup
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub shutup {
	my ($self,$client,$msg,$listener) = @_;

	# On MSN, this command will work as intended. On others, it will turn !mute mode on.
	if ($listener eq "MSN") {
		# Current socket number.
		my $sock = $self->getID;

		print "Debug // Socket: $sock\n";

		# Get our handle.
		my $sn = $self->{Msn}->{Handle};
		$sn = lc($sn);
		$sn =~ s/ //g;

		# If we're already shutted up for this socket...
		if (exists $chaos->{$sn}->{_shutup}->{$sock}) {
			# Turn it off.
			delete $chaos->{$sn}->{_shutup}->{$sock};

			return "Thanks. :-) I'll chat here again.";
		}
		else {
			# Turn it on.
			$chaos->{$sn}->{_shutup}->{$sock} = 1;

			return "Alright. Just type !shutup again to get me to chat here.";
		}
	}
	else {
		# Just turn on mute mode.
		$chaos->{_users}->{$client}->{mute} = 1;

		return "Alright, type !mute to get me to talk again.";
	}
}

{
	Category => 'Bot Utilities',
	Description => 'Shuts the Bot Up',
	Usage => '!shutup',
	Listener => 'All',
};