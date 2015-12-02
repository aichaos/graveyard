#      .   .               <Leviathan>
#     .:...::     Command Name // !copyright
#    .::   ::.     Description // CKS Leviathan Copyright Info.
# ..:;;. ' .;;:..        Usage // !copyright
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub copyright {
	my ($self,$client,$msg) = @_;

	# Return the info.
	my $reply = ".: Copyright Information :.\n\n"
		. "Program: AiChaos Leviathan v. 2.0\n"
		. "Author: Cerone Kirsle\n\n";

	# Find bots.
	my @bots;
	foreach my $bot (keys %{$chaos->{bots}}) {
		if (exists $chaos->{bots}->{$bot}->{client}) {
			push (@bots, $bot);
		}
	}

	my $list = CORE::join (", ", @bots);

	$reply .= "Bots Running: " . scalar(@bots) . "\n"
		. "[$list]\n\n"
		. "This bot is running under a program called AiChaos Leviathan, Copyright "
		. "2005 AiChaos Inc.";

	return $reply;
}
{
	Category => 'General',
	Description => 'CKS Leviathan Copyright Info.',
	Usage => '!copyright',
	Listener => 'All',
};
