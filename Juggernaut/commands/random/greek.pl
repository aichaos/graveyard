#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !greek
#    .::   ::.     Description // Get a random Greek alphabet name.
# ..:;;. ' .;;:..        Usage // !greek
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub greek {
	my ($self,$client,$msg,$listener) = @_;

	# The Greek alphabet.
	my @alpha = (
		"alpha",
		"beta",
		"gamma",
		"delta",
		"epsilon",
		"zeta",
		"eta",
		"theta",
		"iota",
		"kappa",
		"lambda",
		"mu",
		"nu",
		"xi",
		"omicron",
		"pi",
		"rho",
		"sigma",
		"tau",
		"upsilon",
		"phi",
		"chi",
		"psi",
		"omega",
	);

	# Get three words.
	my $one = $alpha [ int(rand(scalar(@alpha))) ];
	my $two = $alpha [ int(rand(scalar(@alpha))) ];
	my $three = $alpha [ int(rand(scalar(@alpha))) ];

	# Return the result.
	return "$one $two $three";
}

{
	Category => 'Random Stuff',
	Description => 'Random Greek Alphabet Name',
	Usage => '!greek',
	Listener => 'All',
};