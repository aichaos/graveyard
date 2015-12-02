#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !nick
#    .::   ::.     Description // Update the bot's MSN nickname.
# ..:;;. ' .;;:..        Usage // !nick <new name>
#    .  '''  .     Permissions // Admin Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub nick {
	my ($self,$client,$msg,$listener) = @_;

	# This command is MSN only.
	return "This command is MSN only." if $listener ne "MSN";

	# Let's convert some "fun" codes like \r!
	$msg =~ s/\\r/\r/ig;

	# This command is Admin Only.
	if (isAdmin($client,$listener)) {
		# Make sure there's a name to set.
		if (length $msg > 0) {
			# Set the name.
			$self->set_name ($msg);

			# Return a reply.
			return "I have changed my name.";
		}
		else {
			# Return an error.
			return "You must provide a name to set, i.e.\n\n"
				. "!nick New Name Here";
		}
	}
	else {
		return "This command is Admin Only.";
	}
}

{
	Restrict => 'Administrator',
	Category => 'Administrator Commands',
	Description => 'Change the MSN Bot\'s Nickname',
	Usage => '!nick <new nickname>',
	Listener => 'MSN',
};