#      .   .               <Leviathan>
#     .:...::     Command Name // !m8b
#    .::   ::.     Description // Magic 8 Ball.
# ..:;;. ' .;;:..        Usage // !m8b <question>
#    .  '''  .     Permissions // Public.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub m8b {
	my ($self,$client,$msg) = @_;

	# Must be a message.
	return "You must give me a question to answer when using this command." unless length $msg > 0;

	# Only Yes/No Questions.
	my @yesno = (
		'do',
		'are',
		'is',
		'does',
		'did',
		'will',
		'am',
	);
	my $valid = 0;
	foreach my $starters (@yesno) {
		next if $valid == 1;
		if ($msg =~ /^$starters/i) {
			$valid = 1;
		}
	}

	# Valid response?
	if ($valid) {
		# Give a response.
		my @replies = (
			"Yes.",               # 1   - Positive Answers
			"Definitely.",        # 2
			"Without a doubt.",   # 3
			"It's possible.",     # 4
			"Very possible.",     # 5
			"It's probable.",     # 6
			"Very probable.",     # 7

			"Maybe.",             # 1   - Unspecific Answers
			"Try again.",         # 2

			"Not very probably.", # 1   - Negative Answers
			"Not probable.",      # 2
			"I doubt it.",        # 3
			"Very unlikely.",     # 4
			"Probably not.",      # 5
			"Impossible.",        # 6
			"No.",                # 7
		);

		return $replies [ int(rand(scalar(@replies))) ];
	}
	else {
		my @replies = (
			"Yes or no questions only, please!",
			"That was not a yes or no question.",
			"Shut up and give me a yes or no question!",
			"I will only answer yes or no questions.",
		);

		return $replies [ int(rand(scalar(@replies))) ];
	}
}
{
	Category    => 'Fun Stuff',
	Description => 'Magic 8-Ball.',
	Usage       => '!m8b <question>',
	Listener    => 'All',
};