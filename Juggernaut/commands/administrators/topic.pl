#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !topic
#    .::   ::.     Description // Update the MSN chat topic.
# ..:;;. ' .;;:..        Usage // !topic [new topic]
#    .  '''  .     Permissions // Public [Admin Only]
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub topic {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we're on MSN.
	if ($listener eq "MSN") {
		# Get our handle.
		my $sn = $self->{Msn}->{Handle};
		$sn = lc($sn);
		$sn =~ s/ //g;

		# If there is a topic to set...
		if ($msg) {
			# This command is Admin Only.
			if (isAdmin($client,$listener)) {
				# Set the topic.
				$chaos->{$sn}->{chat}->{topic} = $msg;

				return "I have set the chat topic to $msg.";
			}
			else {
				return "Setting the topic is Admin Only.";
			}
		}
		else {
			if (exists $chaos->{$sn}->{chat}->{topic}) {
				return "The current chat topic is: " . $chaos->{$sn}->{chat}->{topic};
			}
			else {
				return "There is no chat topic set.";
			}
		}
	}
	else {
		return "Chat topics are supported only on MSN.";
	}
}

{
	Restrict => 'Administrator',
	Category => 'Administrator Commands',
	Description => 'Get/Set the Chat Topic',
	Usage => '!topic [new topic]',
	Listener => 'MSN',
};