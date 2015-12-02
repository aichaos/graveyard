#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !rules
#    .::   ::.     Description // General bot rules.
# ..:;;. ' .;;:..        Usage // !rules
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub rules {
	my ($self,$client,$msg,$listener) = @_;

	my $reply = "<b>:: RULES ::</b>\n\n"
		. "1. DO NOT WARN THE ROBOTS!\n"
		. "2. DO NOT MAKE OTHER BOTS TALK TO ME!\n"
		. "3. DO NOT SPAM OR FLOOD!\n"
		. "4. KEEP THE CONVERSATIONS \"G\" RATED!\n"
		. "5. DO NOT HARASS OR STALK OTHER USERS THROUGH OUR BOTS!\n\n"
		. "If you are blocked from using ONE of our CKS Robots, you will be blocked "
		. "from using ALL of the robots. If you break any of the above rules, you "
		. "will be banned PERMANENTLY from ALL of the CKS Robots. NO EXCEPTIONS.\n\n"
		. "\* Users on the Warners List will be warned AND blocked every time "
		. "they attempt to talk to the CKS bots.";
	return $reply;
}

{
	Category => 'General',
	Description => 'Bot Rules',
	Usage => '!rules',
	Listener => 'All',
};