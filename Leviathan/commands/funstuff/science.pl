#      .   .               <Leviathan>
#     .:...::     Command Name // !science
#    .::   ::.     Description // Random Scientific Name.
# ..:;;. ' .;;:..        Usage // !science
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub science {
	my ($self,$client,$msg) = @_;

	# Create our array of random names.
	my @names = (
		# MAMMALS
		"Antilocapra americana - Antelope",
		"Taxidea taxus - Badger",
		"Euarctos americanus - Black bear",
		"Castor canadensis - Beaver",
		"Lynx rufus - Bobcat",
		"Eutamias - Chipmunk",
		"Nasua narica - Coati",
		"Canis latrans - Coyote",
		"Cervus canadensis - Elk",
		"Thomomys - Gopher",
		"Pecari tajacu - Javelina",
		"Felis concolor - Mountain lion",
		"Ondatra zibethica - Muskrat",
		"Lutra canadensis - Otter",
		"Cynomys - Prairie dog",
		"Erethizon dorsatum - Porcupine",
		"Sylvilagus - Cottontail rabbit",
		"Lepus - Jack rabbit",
		"Procyon lotor - Raccoon",
		"Dipodomys - Kangaroo rat",
		# BIRDS
		"Zenaida macroura - Mourning dove",
		"Zenaida asiatica - White-winged dove",
		"Haliaeetus leucocephalus - Bald eagle",
		"Aquila chrysaetos - Golden eagle",
		"Accipiter cooperii - Cooper's hawk",
		"Buteo jamaicensis - Redtailed hawk",
		"Perisoreus canadensis - Rocky Mountain hawk",
		"Micrathene whitneyi - Elf owl",
		"Bubo virginianus - Great-horned owl",
		"Phasianus colchicas - Pheasant",
		"Colinus virginianus - Bobwhite quail",
		"Lophortyx Gambelii - Gambel's quail",
		"Callipepla squamata - Scaled quail",
		"Geococcyx californianus - Roadrunner",
		"Spizella passerina - Chipping sparrow",
		"Meleagris gallopavo - Wild turkey",
		"Carthartes aura - Vulture turkey",
		"Melanerpes formicivorus - Acorn woodpecker",
		# AMPHIBIANS AND REPTILES
		"Hyla arenicolor - Canyon treefrog",
		"Cnemidophorus - Whiptail lizard",
		"Ambystoma tigrinum - Tiger salamander",
		"Dipsosaurus dorsalis - Desert iguana",
		"Coleonyx variegatus - Banded gecko",
		"Arizona elegans - Glossy snake",
		"Micruroides euryxanthus - Coral snake",
		"M. taeniatus - Striped toad",
	);

	# Return a random name.
	my $reply = $names [ int(rand(scalar(@names))) ];

	return $reply;
}
{
	Category => 'Fun Stuff',
	Description => 'Random Scientific Name.',
	Usage => '!science',
	Listener => 'All',
};