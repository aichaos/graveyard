#      .   .               <Leviathan>
#     .:...::     Command Name // !help
#    .::   ::.     Description // Basic help on the bot.
# ..:;;. ' .;;:..        Usage // !help [category]
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub help {
	my ($self,$client,$msg) = @_;

	undef $msg if $msg eq "help";

	# Specifying a category?
	if (length $msg > 0) {
		# Exiting.
		if ($msg =~ /^exit$/i) {
			# Delete the callback.
			delete $chaos->{clients}->{$client}->{callback};
			return "You have exited the help command.";
		}

		# Categories.
		if ($msg =~ /^1/i) {
			return ":: Command Usage ::\n\n"
				. "In the usages of a command, you may notice some "
				. "symbols: <lt> and <gt>, [ and ], or |.\n\n"
				. "<lt> and <gt> point out required items. When filling in that "
				. "item, do not include the <lt> and <gt> symbols. For example, "
				. "if a command's usage is \"!invite <lt>username<gt>\", you would "
				. "simply write out \"!invite name\@domain.com\"\n\n"
				. "[ and ] are optional fields. For example, the usage of this command "
				. "is \"!help [category]\" - you can type just \"help\" to see the menu, "
				. "or you could type \"help 1\" to come straight here.\n\n"
				. "The pipe symbol, |, means \"or\" - if the command usage has things "
				. "separated by a pipe, it means you must use one of those words in "
				. "the command.";
		}
		else {
			return "Invalid help category. Type \"help\" to see the menu, or \"exit\" to exit.";
		}
	}
	else {
		# Set the callback.
		$chaos->{clients}->{$client}->{callback} = 'help';

		# Return the menu.
		return ".: Help Menu :.\n\n"
			. "Type a number from below to get help with the category it describes:\n\n"
			. "1. Command Usage";
	}
}

{
	Category => 'General',
	Description => 'Basic help on the bot.',
	Usage => '!help [category]',
	Listener => 'All',
};