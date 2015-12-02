#      .   .               <Leviathan>
#     .:...::     Command Name // !rules
#    .::   ::.     Description // Return the AiChaos CKS Bots Rules.
# ..:;;. ' .;;:..        Usage // !rules
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub rules {
	my ($self,$client,$msg) = @_;

	# Return the reply.
	return "<body bgcolor=\"#FFFFFF\"><font face=\"Verdana\" size=\"2\" color=\"#000000\">"
		. "<b>:: Rules for the AiChaos Bots</b>\n\n"
		. "<i>For more details, visit http://www.aichaos.com/index.cgi?display=cks.rules</i>\n\n"
		. "1. <b>Do NOT Warn the robots! (AIM)</b>\n"
		. "2. <b>Do NOT make other bots talk to ours!</b>\n"
		. "3. <b>Do NOT spam or flood our bots!</b>\n"
		. "4. <b>Keep your conversations \"G\" Rated!</b>\n"
		. "5. <b>Do NOT harass OR stalk other users through our bots!</b>\n\n"
		. "If one of our bots says something that is offending to you, "
		. "please send an e-mail to abuse\@aichaos.com explaining what you said "
		. "and how the bot responded.\n\n"
		. "If you are blocked from ONE of the AiChaos bots, you will be blocked "
		. "from ALL of the bots. It is your responsibility to read and understand "
		. "these rules. Blocked users will NOT be unblocked until their time has "
		. "expired. <u>NO EXCEPTIONS.</u>\n\n"
		. "If you had been harassed or stalked by another user through our bots, "
		. "or would like to report an abusive user, please e-mail abuse\@aichaos.com "
		. "about it.\n\n"
		. "<i>Rules last updated on January 19, 2004 \@ 8:45 PM."
		. "</font></body>";
}

{
	Category => 'General',
	Description => 'AiChaos CKS Bots Rules',
	Usage => '!rules',
	Listener => 'All',
};