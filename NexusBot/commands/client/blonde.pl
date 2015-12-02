# COMMAND NAME:
#	BLONDE
# DESCRIPTION:
#	Recieve a random blonde joke.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub blonde {
	my ($self,$client,$msg,$listener) = @_;

	# Create our array of random Yo Mama! jokes.
	my @jokes = (
		"What's the difference between a blonde and a solar-powered calculator? The blonde works in the dark.",
		"How can you tell if a blonde has been using the computer? The joystick is wet.",
		"What does a blonde put behind her ears to make her more attractive? Her ankles.",
		"What do you say to a blonde who won't give in? 'Have another beer.'",
		"How do you make a blonde's eyes twinkle? Shine a flashlight in her ear.",
		"What does a blonde and a beer bottle have in common? They're both empty from the neck up.",
		"What does a blonde owl say? 'What? What?'",
		"How do blonde brain cells die? Alone.",
		"How do you change a blonde's mind? Blow in her ear.",
		"How do you measure a blonde's intelligence? Stick a tire pressure gauge in her ear!",
		"How does a blonde kill a fish? She drowns it.",
		"What do you get when you offer a blonde a penny for her thoughts? Change.",
		"What's five miles long and has an IQ of 60? A blonde parade.",
		"Why did the blonde call the job center? She wanted to find out how to cook food stamps.",
		"A blonde ordered a pizza and the clerk asked if he should cut it in 6 or 12 pieces. The blonde said '6 because I don't think I could manage to eat 12 pieces.'",
		"What do you call a smart blonde? A golden retriever.",
		"Why did God create blondes? Because sheep can't bring beer from the fridge.",
		"Why are blondes hurt by peoples' words? Because people keep hitting them with dictionaries.",
		"How do you drive a blonde insane? Hide her hair dryer.",
		"How do you keep a blonde in suspense? (I'll tell you tomorrow.)",
		"How do you get a blonde to stay in the shower all day? Lend her your shampoo that says 'Lather, rinse, repeat.'",
		"What do you call a blonde on a university campus? A visitor.",
		"A blonde going to London on a plain, how do you steal her window seat? Tell her the seats that are going to London are all in the middle row.",
		"How do you amuse a blonde for hours? Write 'Please Turn Over' on both sides of a sheet of paper.",
		"She was so blonde that she thought a quarterback was a refund.",
		"She was so blonde that she managed to get tangled up in a cordless phone.",
		"She was so blonde that at the bottom of the job application where it said 'Sign Here', she wrote 'Aquarius'",
		"She was so blonde that she sent me a fax with a stamp on it.",
		"She was so blonde that she told me to meet her on the corner of 'Walk' and 'Don't Walk'.",
		"She was so blonde that she tried to put M\&M's in alphabetical order.",
		"She was so blonde that she put lipstick on her head to make up her mind.",
		"She was so blonde that she took a ruler to bed to measure how long she slept.",
		"She was so blonde that when she got an AM radio it took her 10 months to realize she could use it at night.",
		"She was so blonde that she spent 20 minutes staring at the orange juice box because it said 'concentrate.'",
		"She was so blonde that she got stabbed in a shoot-out.",
		"She was so blonde that when she heard that 90\% of crimes happened around the home she moved.",
		"She was so blonde that she thinks Eartha Kitt is a set of gardening tools.",
		"She was so blonde that when she saw a sign for the YMCA she said 'Look! They spelled MACY's wrong!'",
		"She was so blonde that if you offered a penny for her thoughts, you'd get change.",
	);

	# Count the jokes?
	my $count_jokes = 0;

	if ($count_jokes) {
		my $count = 0;
		foreach $item (@jokes) {
			$count++;
		}
		print "\n\nThere are $count Yo Mama jokes.\n\n";
	}

	# Return a random joke.
	$reply = $jokes [ int(rand(scalar(@jokes))) ];

	return $reply;
}
1;