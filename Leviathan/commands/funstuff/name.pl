#      .   .               <Leviathan>
#     .:...::     Command Name // !name
#    .::   ::.     Description // Origin and meaning of first name.
# ..:;;. ' .;;:..        Usage // !name <first name>
#    .  '''  .     Permissions // Public.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub name {
	my ($self,$client,$msg) = @_;

	# Command created by Cerone Kirsle, (C) 2005. Leave this copyright
	# completely intact if you port this command to a different
	# template. Thanks!

	# See if there's a name to check.
	if (length $msg > 0) {
		$msg = lc($msg);
		$msg =~ s/ //g;

		# Get the name site.
		my $src = LWP::Simple::get "http://www.weddingvendors.com/baby-names/meaning/$msg/";
		$src =~ s/\n//g;

		# No matches?
		if ($src =~ /Sorry\, no matches were found/) {
			return "Sorry, no matches were found for that name.";
		}

		my ($name,$origin,$mean,$gender) = ($msg,'undefined','undefined','undefined');

		# Data patterns.
		my %pattern = (
			name   => '<h1>(.*?) \(First Name Origin and Meaning\)<\/h1>',
			origin => '<dt>Origin<dt>\s*<dd>(.*?)<\/dd>',
			mean   => '<dt>Meaning<\/dt>\s*<dd>(.*?)<\/dd>',
			gender => '<dt>Gender<\/dt>\s*<dd>(.*?)<\/dd>',
		);

		# Get the data.
		if ($src =~ /$pattern{name}/) {
			$name = $1;
		}
		if ($src =~ /$pattern{origin}/) {
			$origin = $1;
		}
		if ($src =~ /$pattern{mean}/) {
			$mean = $1;
		}
		if ($src =~ /$pattern{gender}/) {
			$gender = $1;
		}

		# Return it.
		return "Origin and Meaning of First Name $name\n\n"
			. "<b>What is the ethnic origin?</b>\n"
			. "   $origin\n"
			. "<b>What does it mean?</b>\n"
			. "   $mean\n"
			. "<b>What's the gender (commonly)?</b>\n"
			. "   $gender";
	}
	else {
		return "Give me a first name to check, i.e.\n\n"
			. "!name Michael";
	}
}
{
	Category    => 'Fun Stuff',
	Description => 'Origin and meaning of first name.',
	Usage       => '!name <first name>',
	Listener    => 'All',
};