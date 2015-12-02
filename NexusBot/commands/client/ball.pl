# COMMAND NAME:
#	BALL
# DESCRIPTION:
#	Magic 8 Ball
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub ball {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we have some kind of yes/no question.
	my $valid_question = 0;
	my @starters = (
		"do",
		"are",
		"is",
		"does",
		"did",
		"will",
		"am",
	);
	foreach my $question_starter (@starters) {
		if ($msg =~ /^$question_starter/i) {
			$valid_question = 1;
		}
	}

	# If it's a valid question...
	if ($msg) {
		my @responses;
		if ($valid_question == 1) {
			# Give a valid response.
			@responses = (
				"Yes.",
				"It's possible.",
				"It's probable.",
				"Very possible.",
				"Most definitely.",
				"No.",
				"Impossible.",
				"Very unlikely.",
				"I doubt it.",
				"Probably not.",
				"Maybe.",
				"Try again.",
			);
			$reply = $responses [ int(rand(scalar(@responses))) ];
		}
		else {
			@responses = (
				"Yes or no questions only.",
				"A yes or no question that was not.",
				"Shut up and give me a yes or no question.",
				"I will only answer yes or no questions.",
			);
			$reply = $responses [ int(rand(scalar(@responses))) ];
		}
	}
	else {
		$reply = "You must give me a question to answer. The question must "
			. "be in a YES or NO format.\n\n!ball will I become a millionaire?";
	}

	return $reply;
}
1;