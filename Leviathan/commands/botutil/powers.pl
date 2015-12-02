#      .   .               <Leviathan>
#     .:...::     Command Name // !powers
#    .::   ::.     Description // Check your powers on the bot.
# ..:;;. ' .;;:..        Usage // !powers [other username]
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub powers {
	my ($self,$client,$msg) = @_;

	my $username = $client;

	# If a different username is defined...
	if (length $msg > 0) {
		# See if it's properly formatted.
		my ($sender,$name) = split(/\-/, $msg, 2);
		$sender = uc($sender);
		$sender =~ s/ //g;
		$name = lc($name);
		$name =~ s/ //g;

		if (!-e "./clients/$sender\-$name\.txt") {
			return "I don't have any data on that username.";
		}

		$username = CORE::join ('-', $sender, $name);
	}

	# Check powers.
	my $isMaster = &isMaster($username);
	my $isAdmin  = &isAdmin($username);
	my $isMod    = &isMod($username);

	# Prepare the reply.
	my $reply = "Powers for $username\n\n";
	$reply .= "- Botmaster\n" if $isMaster == 1;
	$reply .= "- Administrator\n" if $isAdmin == 1;
	$reply .= "- Moderator\n" if $isMod == 1;
	$reply .= "- Client";

	return $reply;
}

{
	Category => 'Bot Utilities',
	Description => 'Check your powers on the bot.',
	Usage => '!powers [other username]',
	Listener => 'All',
};