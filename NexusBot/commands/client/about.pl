# COMMAND NAME:
#	ABOUT
# DESCRIPTION:
#	Information about this bot.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub about {
	my ($self,$client,$msg,$listener) = @_;

	### NOTICE FROM CHAOS A.I. TECHNOLOGY ###
	#---------------------------------------#
	# This program is released under the    #
	# GNU General Public License. If you    #
	# use this bot, you are required to     #
	# leave this command COMPLETELY intact. #
	# If you need to make an "about"        #
	# command for your bot, then rename     #
	# this command to "cks.pl" (change the  #
	# sub name to "sub cks" also) ahead of  #
	# time.      Thank you.                 #
	#---------------------------------------#
	#########################################

	$reply = "\n<b>Chaos AI Technology CKS NexusBot</b>\n"
		. "Copyright (C) 2004 Chaos AI Technology\n\n"
		. "CKS NexusBot is free software released under the GNU General Public "
		. "License. CKS NexusBot is a chatterbot that learns how to talk by "
		. "chatting with humans.\n\n"
		. "http://chaos.kirsle.net/";

	return $reply;
}
1;