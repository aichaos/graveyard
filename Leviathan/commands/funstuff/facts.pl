#      .   .               <Leviathan>
#     .:...::     Command Name // !facts
#    .::   ::.     Description // Random facts.
# ..:;;. ' .;;:..        Usage // !facts
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub facts {
	my ($self,$client,$msg) = @_;

	# Our list of facts...
	my @facts = (
		"There are only 12 letters in the Hawaiian alphabet.",
		"An adult grizzly bear can decapitate a moose with one swipe of its paw. When it charges it can cover 100 yards in six seconds - faster than a racehorse.",
		"The longest one-syllable word in the English language is 'screeched.'",
		"On a Canadian two dollar bill, the flag flying over the Parliament Building is an American flag.",
		"Barbie's measurements if she were life size: 39-23-33.",
		"All of the clocks in  Pulp Fiction  are stuck on 4:20.",
		"No word in the English language rhymes with month.",
		"A coat hanger is 44 inches long if straightened.",
		"Canada is an Indian word meaning 'Big Village'.",
		"'Dreamt' is the only English word that ends in the letters 'mt'.",
		"The word 'byte' is a contraction of 'by eight.'",
		"The word 'pixel' is a contraction of either 'picture cell' or 'picture element.'",
		"Isaac Asimov is the only author to have a book in every Dewey-decimal category.",
		"Cat's urine glows under a blacklight.",
		"The average ear of corn has eight-hundred kernels arranged in sixteen rows.",
		"The first Ford cars had Dodge engines.",
		"Almonds are members of the peach family.",
		"If you add up the numbers 1-100 consecutively (1+2+3+4+5 etc) the total is 5050.",
		"The symbol on the \"pound\" key (\#) is called an octothorpe.",
		"The maximum weight for a golf ball is 1.62 oz.",
		"The dot over the letter 'i' is called a tittle.",
		"Only humans and horses have hymens.",
		"The state with the longest coastline in the US is Michigan.",
		"Captain Jean-Luc Picard's fish was named Livingston.",
		"'Underground' is the only word in the English language that begins and ends with the letters 'und.'",
		"The international telphone dialing code for Antarctica is 672.",
		"The housefly hums in the middle octave, key of F.",
		"Mr. Snuffleupagas' first name was Alyoisus.",
		"The little bags of netting for gas lanterns (called 'mantles') are radioactive-so much so that they will set of an alarm at a nuclear reactor.",
		"Deborah Winger did the voice of E.T.",
		"There is a word in the English language with only one vowel, which occurs six times: Indivisibility.",
		"No word in the English language rhymes with 'orange.'",
		"In most advertisments, including newspapers, the time displayed on a watch is 10:10.",
		"The only Dutch word to contain eight consecutive consonants is 'angstschreeuw'.",
		"Alfred Hitchcock didn't have a belly button.  It was eliminated when he was sewn up after surgery.",
		"A 'jiffy' is an actual unit of time for 1/100th of a second.",
		"Woodpecker scalps, porpoise teeth and giraffe tails have all been used as money.",
		"The Los Angeles Rams were the first U.S. football team to introduce emblems on their helmets.",
		"Octopi have gardens.",
		"There are 336 dimples on a regulation golf ball.",
		"A group of frogs is called an army.",
		"A group of rhinos is called a crash.",
		"A group of kangaroos is called a mob.",
		"A group of whales is called a pod.",
		"A group of geese is called a gaggle.",
		"A group of ravens is called a murder.",
		"A group of officers is called a mess.",
		"A group of larks is called an exaltation.",
		"A group of owls is called a parliament.",
		"Shrimps' hearts are in their heads.",
	);

	$reply = $facts [ int(rand(scalar(@facts))) ];

	return $reply;
}
{
	Category => 'Fun Stuff',
	Description => 'Random facts.',
	Usage => '!facts',
	Listener => 'All',
};