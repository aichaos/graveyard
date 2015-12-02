#      .   .               <Leviathan>
#     .:...::     Command Name // !warn
#    .::   ::.     Description // Warn an AIM user.
# ..:;;. ' .;;:..        Usage // !warn <botname username|username>
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2005 AiChaos Inc.

sub warn {
	my ($self,$client,$msg) = @_;

	# This command is Master Only.
	return "This command is Master Only!" unless &isMaster($client);

	# The two usages are:
	#    !warn victims-username                 -For warning a user through the current bot.
	#    !warn bots-username victim-username    -For warning a user through another bot.
	return "You must provide a message when calling this command!" unless length $msg > 0;
	my @data = split(/\s+/, $msg);

	if (scalar(@data) == 2) {
		my $botname = shift(@data);
		my $victim  = shift(@data);

		# Format the bot name.
		$botname = lc($botname);
		$botname =~ s/ //g;

		# See if this is a valid AIM bot.
		if (exists $chaos->{bots}->{$botname}->{listener}) {
			if ($chaos->{bots}->{$botname}->{listener} =~ /^(aim|toc)$/i) {
				# Do it.
				$chaos->{bots}->{$botname}->{client}->evil ($victim,0) or return "Error in warning: $!";
				return "I have issued a warning to $victim using the AIM bot, $botname.";
			}
			else {
				return "Error: $botname is not an AIM or TOC bot. Warnings are an AIM-specific function.";
			}
		}
		else {
			return "Error: We do not own $botname and cannot command it to send a warning.";
		}
	}
	elsif (scalar(@data) == 1) {
		my $victim = shift(@data);

		# This is for AIM only then.
		my ($l,$n) = split(/\-/, $client, 2);
		if ($l =~ /^(AIM|TOC)$/i) {
			# Send a warning.
			$self->evil ($victim,0) or return "Error in warning: $!";
			return "I have issued a warning to $victim.";
		}
		else {
			# Not applicable.
			return "Error: $botname is not an AIM or TOC bot. Warnings are an AIM-specific function.";
		}
	}
	else {
		return "Bad number of arguments: the maximum number of objects should be two!";
	}
}
{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Warn an AIM user.',
	Usage => '!warn <bot-username victim-username|victim-username>',
	Listener => 'All',
};