# COMMAND NAME:
#	MENU
# DESCRIPTION:
#	Lists all the commands.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub menu {
	my ($client,$msg) = (shift,shift);

	$reply = ("~MAIN MENU~\n\n"
		. "For full descriptions check out http://chaos.kirsle.net?display=commands\n\n"
		. "<b>Public Commands</b>\n"
		. "!calc [equation] ~ Calculator\n"
		. "!msn [command] ~ MSN Controls\n"
		. "!mstag [username] ~ MSN IM Tag\n"
		. "!status ~ Current Status\n"
		. "!tag [username] ~ AOL IM Tag\n"
		. "!translate [lang]:[string] ~ Translator\n"
		. "!menu ~ This Menu\n\n"
		. "<b>~Admin/Mod Commands</b>\n"
		. "!admin ~ Admin controls\n"
		. "!mod ~ Mod controls\n"
		. "!reload ~ Reload Files");

	return $reply;
}
1;