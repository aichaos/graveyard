#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !valley
#    .::   ::.     Description // Valley of the Green Glass Doors
# ..:;;. ' .;;:..        Usage // !valley
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub valley {
	my ($self,$client,$msg,$listener) = @_;

	# Valley of the Green Glass Doors.
	my @valley = (
		'There are steeples, but there is no church.',
		'There is blood, but no vains.',
		'There are feelings, but no emotions.',
		'There are rolls, but no pastry.',
		'There is wood, there are trees, shrubberies, and seeds, but there are no sprouts.',
		'There are puppies, but no dogs.',
		'There are kittens, but no cats.',
		'There are spools and needles, but no thread.',
		'There is speed but no movement.',
		'There is falling but no impact.',
		'There is passing, but there is no time.',
		'There is running, but you cannot walk.',
		'There is yelling, but no one ever cries.',
		'There is a hall, but no town.',
		'There is a village, but no idiot.',
		'There are tools, but no garden.',
		'There are creeks, but no water.',
		'There are tools, but nothing is broken.',
		'There is glass, but no drink.',
		'There are reeds, but no marsh.',
		'There is soon, but never now.',
		'There is a pattern, but there is no order.',
		'There is vanilla, but there is no chocolate.',
		'There are puzzles, but no confusion.',
		'There are bottles, but there are no cans.',
		'There is a ball, but never a bat.',
		'There is school, but no learning.',
		'There are fools, but no idiots.',
		'There is suffocation, but no death.',
		'There are glasses, but no spectacles.',
		'There are troops, and a fleet, but no war.',
		'There are sneers, jeers, and looks, but no stares, glares, or "evil eyes."',
		'There are grooms, but no brides.',
		'There are hills, but no mountains.',
		'There are malls, but no shops.',
		'There is weed, but no pipe.',
		'There is passion, but no hatred.',
		'There is suffering, but there is no pain.',
		'There is need, but no want.',
		'There is supply, but no demand.',
		'There are guesses, but no answers.',
		'There are worries, but no one is concerned.',
		'There is sweet, but there is no sour.',
		'There is bass, but no treble.',
		'There are Cheerios, but no Lucky Charms.',
		'There are kisses, but no hugs.',
		'There are books, but no reading.',
		'There is sickness, but no fevers.',
		'There is cheese, but no crackers.',
		'There are batteries, but no energy.',
		'There is programming, but no programs.',
		'There are balloons, but no helium.',
		'There are spoons, but no silverware.',
		'There are coordinates, but nowhere to go.',
		'There are doors, but no entrances.',
		'There are streets, but no paths.',
		'There are missionaries, but no evangelicals.',
		'There are scanners, but no technology.',
		'There are walls, but no boundaries.',
		'There are roofs, but no ceilings.',
		'There is spelling, but there are no words.',
		'There are bees, but no insects.',
		'There are seagulls, but no birds.',
		'There are mammals, but no animals.',
		'There are trees, but no plants.',
		'There is grass, and weeds, but no flowers.',
		'There are floors, but no ground.',
		'There is pepper, but no salt.',
		'There are inns, but no hotels.',
		'There are riddles, but no jokes.',
		'There is green, but no red, blue, or orange.',
		'There are teenagers, but no adults.',
		'There are feet, but no shoes.',
		'There is Google, but no MSN.',
		'There are Instant Messages, but no chat.',
		'There are cookies, but nothing to eat.',
		'There is food, but no water.',
		'There are expressions, but no faces.',
		'There are streets, but no pavement.',
		'There are messages, but no conversation.',
		'There is randomness, but no change.',
		'There are apples, but no fruit.',
		'There are commands, but no orders.',
		'There is common, but no similarities.',
		'There is Hawaii, but no Alaska.',
		'There is a moon, but no sun.',
	);

	# Pick a random item.
	my $item = $valley [ int(rand(scalar(@valley))) ];

	return "$item Only in the Valley of the Green Glass Doors.";
}

{
	Category => 'Fun & Games',
	Description => 'Valley of the Green Glass Doors',
	Usage => '!valley',
	Listener => 'All',
};