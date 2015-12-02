#      .   .               <Leviathan>
#     .:...::     Command Name // !gender
#    .::   ::.     Description // Gender Guesser.
# ..:;;. ' .;;:..        Usage // !gender <first name>
#    .  '''  .     Permissions // Public.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub gender {
	my ($self,$client,$msg) = @_;

	# Created by Cerone Kirsle, (C) 2004. Leave this copyright
	# completely intact if you port this command to a different
	# template. Thanks!

	# See if there's a name to check.
	if (length $msg > 0) {
		# Get the gender guesser site.
		my $src = get "http://cgi.sfu.ca/~gpeters/cgi-bin/pear/gender.php?firstname=$msg" or return "Error: Could not access data.";
		$src =~ s/\n//ig;
		$src =~ s/<(.|\n)+?>//g;
		$src = lc($src);

		if ($src =~ /it\'s a (.*?)!based on popular usage, it is (.*?) times more common for (.*?) to be a (.*?)\'s name\.the popularity of (.*?) is: (.*?) \(where 0 = extremely rare\, 6 = super popular\)/i) {
			my $gender = $1;
			my $likely = $2;
			my $pop = $6;

			return "It's a $gender!\n\n"
				. "Based on popular usage, it is $likely times more likely for $msg to "
				. "be a $gender\'s name.\n\n"
				. "The popularity of $msg is: $pop\n"
				. "(Where 0 = extremely rare and 6 = extremely common)";
		}
		else {
			return "I consider $msg to be a pretty rare name, so I'm not able "
				. "to provide any information on it, sorry! Please try another name.";
		}
	}
	else {
		return "Give me a first name to check, i.e.\n\n"
			. "!gender Michael";
	}
}
{
	Category    => 'Fun Stuff',
	Description => 'Gender Guesser.',
	Usage       => '!gender <first name>',
	Listener    => 'All',
};