#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !about
#    .::   ::.     Description // Information about CKS Juggernaut
# ..:;;. ' .;;:..        Usage // !about
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub about {
	my ($self,$client,$msg,$listener) = @_;	

	# This is where you talk about your bot in general.
	# Note to the botmaster: If you modify this command,
	# please include that it was built on CKS Juggernaut.
	my $reply = "<b>CKS Juggernaut</b>\n\n"
		. "This bot was built using CKS Juggernaut by Chaos AI Technology.\n\n"
		. "This bot is free software: You may duplicate and redistribute it under "
		. "the terms of the GNU General Public license, version 1.0 or (at your "
		. "convenience) any later version.";

	return $reply;

}

{
	Category => 'General',
	Description => 'About CKS Juggernaut',
	Usage => '!about',
	Listener => 'All',
};