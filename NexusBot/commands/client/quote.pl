# COMMAND NAME:
#	QUOTE
# DESCRIPTION:
#	Recieve a random inspirational quote.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub quote {
	my ($self,$client,$msg,$listener) = @_;

	# Our array of quotes.
	my @quotes = (
		"Doubt is undoubtedly a good thing. -David Seaton",
		"Your circumstances may be uncongenial, but they shall not long remain so if you but perceive an Ideal and strive to reach it. You cannot travel within and stand still without. -James Allen",
		"Nobody gets to live life backwards. Look ahead, that's where your future lies. -Ann Landers",
		"Sometimes humans beg for battles to be taken away from them, not realizing that only in struggling with shadows is the Light made manifest. - W. Michael Gear",
		"It is a wise man indeed, who well in advance, offers God all his thankfulness and praise, in anticipation of life's unavoidable trials, tribulations and pitfalls. - Joseph P. Martino",
		"O Lord, help me not to despise or oppose what I do not understand. -Ruth Graham",
		"Life is like a game of poker. You never know if you are going to get a good or bad hand. You have to take chances with the cards you have and maybe you'll win and the only way to win is to play. -Courtney Cooper",
		"MOM is WOW spelled upside down. -Steven Troy Larson",
		"Love is not a word, it's the world. -Dev Kishore",
		"Be as courageous as a lion. Don't back away from your fear. Face it, head on, and conquer your fear. -Michelle Robin",
		"I want you to always remember this....... In life it is never, ever, ever too late to change. Remember that ... hold on to that. At the bleakest of moments history has been made. Sometimes it's only at our darkest moments that we can see the light. There is always hope in life because there is always GOD. -Christine Michelle",
		"To move on, seek God. -S. Aquisap",
	);

	my $quotes;
	my $reply = $quotes [ int(rand(scalar(@quotes))) ];

	return $reply;
}
1;