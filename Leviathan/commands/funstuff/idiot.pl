#      .   .               <Leviathan>
#     .:...::     Command Name // !idiot
#    .::   ::.     Description // How to keep an idiot busy.
# ..:;;. ' .;;:..        Usage // !idiot
#    .  '''  .     Permissions // Public.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub idiot {
	my ($self,$client,$msg) = @_;

	# Hashref keys (name of callback and key to store the step in).
	my $callback = 'idiot';
	my $key = '_idiot';

	# Array of things to say.
	my @ramble = (
		"I'm about to teach you how to keep an idiot occupied. You ready?",
		"Are you sure you want to know how to keep an idiot occupied?",
		"Are you absolutely sure?",
		"How about absolutely positively sure?",
		"Alright, I'm about to tell you. You still want to know?",
		"Just say the word one more time and I'll tell you.",
		"Congratulations, you now know how to keep an idiot occupied!",
	);

	# Callback?
	if ($chaos->{clients}->{$client}->{callback} eq $callback) {
		# Exiting?
		if ($msg =~ /exit/i) {
			# Exit.
			delete $chaos->{clients}->{$client}->{callback};
			delete $chaos->{clients}->{$client}->{$key};
			return "Aww... you're no fun!";
		}
		else {
			# Give them the next step.
			my $step = $chaos->{clients}->{$client}->{$key};
			my $last = (scalar(@ramble)) - 1;
			if ($step == $last) {
				# Last step.
				delete $chaos->{clients}->{$client}->{callback};
				delete $chaos->{clients}->{$client}->{$key};
				return $ramble[$last];
			}
			else {
				# Continue rambling.
				$chaos->{clients}->{$client}->{$key}++;
				return $ramble[$step];
			}
		}
	}
	else {
		# Set the callback and counter.
		$chaos->{clients}->{$client}->{callback} = $callback;
		$chaos->{clients}->{$client}->{$key} = 1;

		# Return step #0.
		return $ramble[0];
	}
}
{
	Category    => 'Fun Stuff',
	Description => 'How to keep an idiot occupied.',
	Usage       => '!idiot',
	Listener    => 'All',
};