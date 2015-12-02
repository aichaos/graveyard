#      .   .               <Leviathan>
#     .:...::     Command Name // !aol
#    .::   ::.     Description // 101 uses for an AOL disc.
# ..:;;. ' .;;:..        Usage // !aol
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub aol {
	my ($self,$client,$msg) = @_;

	# Easier to make this a scalar first.
	my @aol = (
		'Mini cutting board (great for the office or the car, use metal door for knife).',
		'Attach it to a ruler and presto! - you\'ve got a fly swatter.',
		'Construct a life size replica of Stonehenge.',
		'At a restaurant, shove one under a wobbling table leg.',
		'Money clip (use metal door and discard the plastic case...the "rich nerd" look is IN this year).',
		'Eye patch (for one-eyed software pirates).',
		'Christmas ornaments (the more the merrier).',
		'Give them to young children to use as building blocks.',
		'Glue them to the bottom of the space shuttle and use them as re-entry burn tiles.',
		'Dentures (melt & form them into new teeth for grandma).',
		'Room dividers for hamsters.',
		'Drink coasters.',
		'Use multiple disks to create an ideal door stopper.',
		'Ice scraper.',
		'Bathroom tile.',
		'Bookmark.',
		'Mini frisbee.',
		'Air hockey puck.',
		'Dog chew toy.',
		'Dart board.',
		'Pooper scooper.',
		'Grill scraper.',
		'Use them for karate board-breaking demonstrations (save a tree).',
		'Wrist slicer - after receiving first AOL bill (use metal door).',
		'Conversation piece for coffee table.',
		'Destroy them - smash, burn, or run over to relieve stress.',
		'Light switch cover.',
		'Chinese throwing stars (tape 2 together).',
		'Clay pigeons for target practice.',
		'Greeting card (bind two together at one end).',
		'Halloween treat (give them away all night long).',
		'Bullet proof vest (arrange together in triple thickness).',
		'Firewood.',
		'Bird house.',
		'Paper weights.',
		'Pen holders (make a box without a top).',
		'Post it-notes holder.',
		'Refrigerator magnet (glue a magnet to the back).',
		'A very sturdy base for putting the motorcycle sidestand on when parking on soft surfaces.',
		'Keep \'em in the trunk for extra traction in the snow.',
		'Solar Eclipse Glasses (open door and look through disk at the sun/moon --actually works).',
		'Placing one in each back pocket helps children who get paddled by the coach. This spreads the force to a wider area.',
		'Make an AOL disk & pasta casserole.',
		'Incense burners (put stick in hole of disk hub and light the incense.',
		'Bug Shield (glue a bunch to the front of your car\'s hood).',
		'Put them on car windshields at the mall (along with this list).',
		'Melt the plastic of the disks into a giant sculpture.',
		'Hand them out as party favors.',
		'Hidden/spare key holder (crack open 1 side, insert key and then place near door. Completely safe...who would want an AOL disk?)',
		'Vertical blinds.',
		'Be an AOL diskette surgeon and dissect a diskette.',
		'Bench press weights (I can press 120).',
		'Grind \'em up and refertilize the front lawn.',
		'The new "Domino\'s stuffed-crust pizza" filling.',
		'Tell the kids to leave warm milk & AOL disks for Santa.',
		'Brake shoes.',
		'House insulation.',
		'Recycle them for the scrap metal.',
		'Kitchen tile for Bill Gates\' new mansion in Seatle (walk all over the competition)',
		'Hockey Puck.',
		'Add water and special plant life to make a Chia-Disk.',
		'Noise maker for your bike spokes (why damage your valuable baseball cards).',
		'Put one on a leash and drag it along as you walk...makes the perfect pet.',
		'Poker chips.',
		'Baseball practice (throw them up in the air and hit them with the bat).',
		'Keychain (Put a key ring through one of the writeprotect holes and you\'ve got a snappy executive bathroom keychain for the office).',
		'Mail to 10 friends-start an AOL chain-letter (add a disk with each link).',
		'Earmuffs (glue some fur on one side, then attach a U-shaped piece of bent coath anger to both disks).',
		'Grind them up to make fake snow.',
		'Earrings (put loop into write-protect hole).',
		'Dental floss (use actual disk).',
		'Use them for zipper pulls (instead of ski lift tickets).',
		'When your collection of disks reaches 52, use them for a deck of cards.',
		'Use them to fill potholes.',
		'Hood ornament.',
		'Snow blower replacement blades.',
		'Put them in your shirt pocket to make you look smart.',
		'Make two stacks of 10 and use them as heels for platform shoes.',
		'Rubik\'s cube case (make into box).',
		'Shipping material (keeps your photos from being bent in the mail).',
		'Protect your table from burns caused by hot pots and pans.',
		'Snack trays (great for holding hors d\'oeuvres at parties).',
		'Give them as stocking stuffers to all those people who piss you off.',
		'Fly paper (use actual disk and put string through middle, hang 2" apart and apply honey to disks).',
		'Pocket protector.',
		'They make a *dandy* addition to a #+&% neighbor\'s back yard. Better yet, get them to actually install it on their computer.',
		'Use them as elbow and knee pads.',
		'Wax scraper for snowboards.',
		'Use them to decorate your aquarium and create Computer City under water.',
		'Tape a few together and use them as a mouse pad.',
		'Collect a large mass and detonate a supernova.',
		'A wind clacker (similar to a wind chime).',
		'Soap dish (remove metal to prevent rusting).',
		'Row markers for your vegetable garden. (carrots, beans, peas....)',
		'Makes the perfect dance floor for your ant colony.',
		'Bread roller (use actual disks and put rod through center-use about 100).',
		'Hot glue gun resting/protecting pad.',
		'Baby mobile.',
		'Fence (may need a few thousand).',
		'Toe tags for mortuaries. Great for identifying dead computer nerds.',
		'Wonderbra inserts for that Madonna-techno look.',
	);

	my $result;
	my $rand;
	if (length $msg > 0 && $msg !~ /[^0-9]/) {
		$msg--;
		$rand = $msg;
		$result = $aol[$msg];
	}
	else {
		# Pick a random item.
		$rand = int(rand(scalar(@aol)));
		$result = $aol[$rand];
	}

	# Format the result.
	$result =~ s/^\t+//ig;
	$result =~ s/\s+$//ig;

	# Generate this number.
	my $num = '#' . ($rand + 1);

	# Return the result.
	return "Use $num for an AOL Disc:\n\n"
		. $result;
}
{
	Category => 'Fun Stuff',
	Description => '101 uses for an AOL disc.',
	Usage => '!aol',
	Listener => 'All',
};