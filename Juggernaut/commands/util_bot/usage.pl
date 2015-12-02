#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !usage
#    .::   ::.     Description // Usage about a command.
# ..:;;. ' .;;:..        Usage // !usage <command>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub usage {
	my ($self,$client,$msg,$listener) = @_;

	# If they have a request...
	if (length $msg > 0) {
		$msg = lc($msg);
		$msg =~ s/ //g;

		# If it exists...
		if (!exists $chaos->{_system}->{commands}->{$msg}) {
			return "That command does not exist.";
		}

		# If a usage exists.
		if (defined $chaos->{_system}->{commands}->{$msg}->{Usage}) {
			my $usage = $chaos->{_system}->{commands}->{$msg}->{Usage};
			$usage =~ s/\</&lt;/ig;
			$usage =~ s/\>/&gt;/ig;
			return "Usage for $msg:\n\n"
				. $usage;
		}
		else {
			return "No usage information for the command has been located. "
				. "Please inform my botmaster by typing !call master";
		}
	}
	else {
		return "Give me a command to look up the usage for, or type:\n\n"
			. "!usage usage";
	}
}

{
	Category => 'Bot Utilities',
	Description => 'Usage on a Command',
	Usage => '!usage <command>',
	Listener => 'All',
};