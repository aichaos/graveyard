#      .   .               <Leviathan>
#     .:...::     Command Name // !password
#    .::   ::.     Description // Random Password Generator.
# ..:;;. ' .;;:..        Usage // !password
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub password {
	my ($self,$client,$msg) = @_;

	# Accept only numeric values.
	if ($msg =~ /[^0-9]/) {
		return "You may only use a numeric value for the number of characters you "
			. "want in your password.";
	}

	# Our array of useable items.
	my @options = qw (A a B b C c D d E e F f G g H h I i J j K k L l M m N n O o P p Q q R r S s T t U u V v W w X x Y y Z z);
	push (@options, qw (0 1 2 3 4 5 6 7 8 9 < >));

	# Get the length of the message.
	my $size = $msg || 10;

	# We'll only accept anywhere between 3 and 100 characters.
	if ($size < 3 || $size > 100) {
		return "A password length may only be between 3 and 100 characters.";
	}

	# Go on a loop!
	my ($i,$password) = (0,'');
	for ($i = 0; $i <= $size; $i++) {
		$password .= $options [ int(rand(scalar(@options))) ];
	}

	# Filter the HTML characters.
	$password =~ s/</&lt;/ig;
	$password =~ s/>/&gt;/ig;

	# Return the password.
	return "Password: $password";
}
{
	Category => 'Utilities',
	Description => 'Random Password Generator.',
	Usage => '!password [length]',
	Listener => 'All',
};