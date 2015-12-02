#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !echo
#    .::   ::.     Description // Start the annoying echo!
# ..:;;. ' .;;:..        Usage // !echo
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub echo {
	my ($self,$client,$msg,$listener) = @_;

	# If we're in a callback...
	if ($chaos->{_users}->{$client}->{callback} eq "echo") {
		# If they're exiting.
		if ($msg eq "exit") {
			delete $chaos->{_users}->{$client}->{callback};
			delete $chaos->{_users}->{$client}->{_echo}->{count};
			return "Alright, that got annoying anyway. :-)";
		}
		else {
			# Every 10 messages, tell them how to quit.
			if ($chaos->{_users}->{$client}->{_echo}->{count} == 10) {
				$chaos->{_users}->{$client}->{_echo}->{count} = 0;
				return "$msg\n\nType 'exit' to get me to stop repeating you.";
			}
			else {
				$chaos->{_users}->{$client}->{_echo}->{count}++;
				return $msg;
			}
		}
	}
	else {
		# Start being annoying!
		$chaos->{_users}->{$client}->{callback} = "echo";
		$chaos->{_users}->{$client}->{_echo}->{count} = 0;
		return "Alright, I'm going to start echoing you. Type 'exit' to stop.";
	}
}

{
	Category => 'Fun & Games',
	Description => 'Start the Annoying Echo',
	Usage => '!echo',
	Listener => 'All',
};