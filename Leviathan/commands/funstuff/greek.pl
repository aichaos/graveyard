#      .   .               <Leviathan>
#     .:...::     Command Name // !greek
#    .::   ::.     Description // Random greek alphabet name.
# ..:;;. ' .;;:..        Usage // !greek
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub greek {
	my ($self,$client,$msg) = @_;

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
	Category => 'Fun Stuff',
	Description => 'Random greek alphabet name.',
	Usage => '!greek',
	Listener => 'All',
};