#      .   .               <Leviathan>
#     .:...::     Command Name // !valentine
#    .::   ::.     Description // Happy Valentine's Day!
# ..:;;. ' .;;:..        Usage // !valentine
#    .  '''  .     Permissions // Easter Egg
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub valentine {
	my ($self,$client,$msg) = @_;

	# Listeners?
	my ($lis,$nick) = split(/\-/, $client, 2);
	if ($lis =~ /^(AIM|TOC|HTTP)$/i) {
		$reply = "<body bgcolor=\"#FFFFFF\">"
			. "<font face=\"Courier New,Courier\" size=\"2\" color=\"#FF0000\"><b>\n"
			. "  ###      ###\n"
			. " #####    #####\n"
			. "#######  #######  Happy Valentine's\n"
			. "################        Day!\n"
			. "################\n"
			. " ##############\n"
			. "  ############\n"
			. "   ##########\n"
			. "    ########\n"
			. "     ######\n"
			. "      ####\n"
			. "       ##</b></font></body>";
		return $reply;
	}
	elsif ($lis eq 'MSN') {
		$self->sendMessage ("  ###      ###\n"
			. " #####    #####\n"
			. "#######  #######  Happy Valentine's\n"
			. "################        Day!\n"
			. "################\n"
			. " ##############\n"
			. "  ############\n"
			. "   ##########\n"
			. "    ########\n"
			. "     ######\n"
			. "      ####\n"
			. "       ##",
			Font   => 'Courier New',
			Color  => '0000FF',
			Effect => 'B',
		);
		return '<noreply>';
	}

	# Return the reply.
	return "\n  ###      ###\n"
		. " #####    #####\n"
		. "#######  #######  Happy Valentine's\n"
		. "################        Day!\n"
		. "################\n"
		. " ##############\n"
		. "  ############\n"
		. "   ##########\n"
		. "    ########\n"
		. "     ######\n"
		. "      ####\n"
		. "       ##";
}
{
	Hidden      => 1,
	Category    => 'General',
	Description => 'Happy Valentine\'s Day!',
	Usage       => '!valentine',
	Listener    => 'All',
};
