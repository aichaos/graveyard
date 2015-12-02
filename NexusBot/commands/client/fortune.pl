# COMMAND NAME:
#	FORTUNE
# DESCRIPTION:
#	A fortune cookie!
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub fortune {
	my ($self,$client,$msg,$listener) = @_;

	# The array of fortunes.
	my @fortunes = (
		"The love of your life will appear in front of you unexpectedly.",
		"You or a close friend will be married within a year.",
		"You are a traveler at heart. There will be many journeys.",
		"Take a vacation, you will have unexpected gains.",
		"Twinkle twinkle little nooky, don't you wish you weren't a rooky?",
		"Don't forget that your roots need watering.",
		"Today it's up to you to create the peacefulness you long for.",
		"You are about to embark on a most delightful journey.",
		"Feel the tingle, it's your time to mingle.",
		"A liar is not believed even though he tells the truth.",
		"Prejudice is the child of ignorance.",
		"Do not give a man a fish, but teach him how to fish.",
		"You never hesitate to tackle the most difficult problems.",
		"You have a heart of gold.",
		"Present your best ideas today to an eager and welcoming audience.",
		"He who knows he has enough is rich.",
		"Keep your plans secret for now.",
		"Traveling this year will bring your life into greater perspective.",
		"Don't let friends impose on you. Work calmly and silently.",
		"Ask advice, but use your own common sense.",
		"You will receive many beauteous gifts in the years ahead.",
		"Joys are often the shadows, cast by sorrows.",
		"You are going to have some new clothes.",
		"You will be attracted to an older, more experienced person.",
		"One who admires you greatly is hidden before your eyes.",
		"Don't behave with cold manners.",
		"Over self-confidence is equal to being blind.",
		"Everyone has ambitions.",
		"Your ability to find the silly in the serious will take you far.",
		"Good news will be brought to you by mail.",
		"Stop searching forever, happiness is just next to you.",
		"Don't be afraid to take that big step.",
		"Your ideals are well within your reach.",
		"Your luck has been completely changed today.",
		"You will become more passionate and determined about your convictions.",
		"You will emerge from uncertainty into great peace and freedom.",
		"Dedicate yourself with a calm mind to the task and hand.",
	);

	$reply = $fortunes [ int(rand(scalar(@fortunes))) ];

	return $reply;
}
1;