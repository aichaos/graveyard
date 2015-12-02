# COMMAND NAME:
#	MENU
# DESCRIPTION:
#	Lists all the commands.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub menu {
	my ($self,$client,$msg,$listener) = @_;

	# See if a category was chosen.
	if ($msg) {
		if ($msg eq "1") {
			$reply = "<b>:: General Commands ::</b>\n\n"
				. "!about :: About Me\n"
				. "!gb :: Random Guestbook Entry\n"
				. "!sign [msg] :: Sign my guestbook\n"
				. "!chat :: Join the MSN Chatroom\n"
				. "!menu :: Show this Menu\n"
				. "!status :: Current Bot Status";
		}
		elsif ($msg eq "2") {
			$reply = "<b>:: Fun and Games ::</b>\n\n"
				. "!ball [question] :: Magic 8 Ball\n"
				. "!die [number] :: Roll a Die!\n"
				. "!fortune :: Get your Fortune\n"
				. "!guess [number] :: Guess My Number (1-10)\n"
				. "!leet [message] :: Make your text l33t\n"
				. "!rps [choice] :: Rock, Paper, Scissors\n"
				. "!tag [username] :: IM Tag\n"
				. "!translate [lang]:[msg] :: Azulian/English Translator\n";
		}
		elsif ($msg eq "3") {
			$reply = "<b>:: Random Stuff ::</b>\n\n"
				. "!blonde :: Random Blonde Joke\n"
				. "!die [number] :: Roll a Die!\n"
				. "!facts :: Random Fact\n"
				. "!fortune :: Random Fortune\n"
				. "!gb :: Random Guestbook Entry\n"
				. "!quote :: Random Inspirational Quote\n"
				. "!ssi :: Random Shakespeare Insult\n"
				. "!yomama :: Random Yo Mama Joke";
		}
		elsif ($msg eq "4") {
			$reply = "<b>:: Utilities ::</b>\n\n"
				. "!aim [command] :: AIM Commands (similar to shortcut URLs)\n"
				. "!apply [position] :: Apply for promotion!\n"
				. "!bug [report] :: Report a Bug\n"
				. "!calc [equation] :: Calculator\n"
				. "!define [word] :: Webster's Dictionary\n"
				. "!formalize [string] :: Formalize a String\n"
				. "!google [string] :: Google Search\n"
				. "!info [position] :: Info about a user position\n"
				. "!ipshards [ip addr] :: Convert an IP to Shards ID No.\n"
				. "!lcstr [string] :: Lowercase a String\n"
				. "!ucstr [string] :: Uppercase a String\n"
				. "!msn [command] :: MSN Command (similar to AIM commands)\n"
				. "!mute :: Toggle the bot to talk to you\n"
				. "!report [user]:[why] :: Report an abusive user\n"
				. "!status :: Current Bot Statistics\n"
				. "!suggest [message] :: Make a suggestion\n"
				. "!updates :: Check for recent updates\n";
		}
		elsif ($msg eq "5") {
			$reply = "<b>:: Feedback Commands ::</b>\n\n"
				. "!apply [position] :: Apply for promotion!\n"
				. "!bug [report] :: Report a Bug\n"
				. "!report [user]:[why] :: Report an Abusive User\n"
				. "!suggest [message] :: Make a Suggestion";
		}
		elsif ($msg eq "6") {
			$reply = "<b>:: Higher-Level Commands ::</b>\n\n"
				. "--Moderator Commands--\n"
				. "!block [listener]-[user] :: Block a user\n"
				. "!isevil [username] :: List blocks against a user\n"
				. "!unblock [username] :: Unblock a user\n"
				. "!unwarn [username] :: Unwarn a user\n"
				. "!userinfo [listener]-[name] :: User Info\n"
				. "!warn [username] :: Warn a user\n\n"
				. "--Super Mod Commands--\n"
				. "!alert [message] :: Send an MSN alert\n"
				. "!away [message] :: Set an away Status\n"
				. "!return :: Return from Away\n\n"
				. "--Admin Commands--\n"
				. "!socks :: List all MSN Conversations\n"
				. "!join [socket] :: Join an MSN conversation\n\n"
				. "--Super Admin Commands--\n"
				. "!kill [socket] :: Kill a Socket\n\n"
				. "--Master Commands--\n"
				. "(undisplayed)";
		}
		else {
			$reply = "Invalid category number.";
		}
	}
	else {
		$reply = "<b>~Main Menu~</b>\n\n"
			. "For a list of commands, type !menu (category) for a category "
			. "number listed below.\n\n"
			. "1 :: General\n"
			. "2 :: Fun and Games\n"
			. "3 :: Random Stuff\n"
			. "4 :: Utilities\n"
			. "5 :: Feedback\n"
			. "6 :: Higher-Level Commands";
	}

	return $reply;
}
1;