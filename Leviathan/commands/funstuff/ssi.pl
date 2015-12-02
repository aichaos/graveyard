#      .   .               <Leviathan>
#     .:...::     Command Name // !ssi
#    .::   ::.     Description // Random Shakespearean Insults.
# ..:;;. ' .;;:..        Usage // !ssi
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub ssi {
	my ($self,$client,$msg) = @_;

	# Our list of insults.
	my @one = (
		"beslubbering",
		"infectious",
		"errant",
		"spongy",
		"pribbling",
		"mangled",
		"warped",
		"lumpish",
		"impertinent",
		"paunchy",
		"yeasty",
		"craven",
		"reeky",
		"droning",
		"bawdy",
		"unmuzzled",
		"qualling",
	);
	my @two = (
		"beef-witted",
		"full-gorged",
		"dread-bolted",
		"rude-growing",
		"ill-nurtured",
		"hell-hated",
		"tickle-brained",
		"hasty-witted",
		"fool-born",
		"ill-breeding",
		"weather-bitten",
		"common-kissing",
		"plume-plucked",
		"doghearted",
		"bat-fowling",
		"sheep-biting",
		"motley-minded",
	);
	my @three = (
		"haggard",
		"barnacle",
		"death-token",
		"pignut",
		"maggot-pie",
		"joit-head",
		"varlet",
		"horn-beast",
		"gudgeon",
		"lout",
		"wagtail",
		"canker-blossom",
		"miscreant",
		"codpiece",
		"baggage",
		"ratsbane",
		"measle",
	);

	my ($one,$two,$three);
	my $first = $one [ int(rand(scalar(@one))) ];
	my $second = $two [ int(rand(scalar(@two))) ];
	my $third = $three [ int(rand(scalar(@three))) ];

	my $reply = "Thou $first $second $third!";

	return $reply;
}
{
	Category => 'Fun Stuff',
	Description => 'Random Shakespearean Insults.',
	Usage => '!ssi',
	Listener => 'All',
};