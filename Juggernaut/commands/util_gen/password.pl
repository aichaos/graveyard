#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !password
#    .::   ::.     Description // Random password generator.
# ..:;;. ' .;;:..        Usage // !password [length]
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub password {
	my ($self,$client,$msg,$listener) = @_;

	# Accept only numeric values.
	if ($msg =~ /[^0-9]/) {
		return "You may only use a numeric value for the number of characters you "
			. "want in your password.";
	}

	# Our array of useable items.
	my @options = (
		'A', 'a', 'B', 'b', 'C', 'c', 'D', 'd',
		'E', 'e', 'F', 'f', 'G', 'g', 'H', 'h',
		'I', 'i', 'J', 'j', 'K', 'k', 'L', 'l',
		'M', 'm', 'N', 'n', 'O', 'o', 'P', 'p',
		'Q', 'q', 'R', 'r', 'S', 's', 'T', 't',
		'U', 'u', 'V', 'v', 'W', 'w', 'X', 'x',
		'Y', 'y', 'Z', 'z', '0', '1', '2', '3',
		'4', '5', '6', '7', '8', '9', '<', '>',
	);

	# Get the length of the message.
	my $size = $msg || 10;

	# We'll only accept anywhere between 3 and 100 characters.
	if ($size < 3 || $size > 100) {
		return "A password length may only be between 3 and 100 characters.";
	}

	# Go on a loop!
	my $password;
	while ($size >= 0) {
		$password .= $options [ int(rand(scalar(@options))) ];

		$size--;
	}

	# Filter the HTML characters.
	$password =~ s/</&lt;/ig;
	$password =~ s/>/&gt;/ig;

	# Return the password.
	return "Password: $password";
}

{
	Category => 'General Utilities',
	Description => 'Random Password Generator',
	Usage => '!password',
	Listener => 'All',
};