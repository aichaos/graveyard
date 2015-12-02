#      .   .               <Leviathan>
#     .:...::     Command Name // !define
#    .::   ::.     Description // Dictionary.com Definitions.
# ..:;;. ' .;;:..        Usage // !define <word>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub define {
	my ($self,$client,$msg) = @_;

	# If there's a message to define...
	if (length $msg > 0) {
		my $src = LWP::Simple::get "http://dictionary.reference.com/search?q=$msg" or return "Could not get dictionary!";
		$src =~ s/\n/ /g;

		# Get the first definition.
		if ($src =~ /<OL><LI>(.*?)<\/LI>/i) {
			my $def = $1;
			$def =~ s/<(.|\n)+?>//ig;

			return "Dictionary.com defines $msg as:\n\n"
				. "1. $def";
		}
		else {
			return "Could not obtain the definition to $msg!";
		}
	}
	else {
		return "Please provide a message when calling this command.";
	}
}
{
	Category => 'Utilities',
	Description => 'Dictionary.com Definitions',
	Usage => '!define <word>',
	Listener => 'All',
};