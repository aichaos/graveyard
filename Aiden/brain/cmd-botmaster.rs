/*
	AidenBot RiveScript
	-------------------
	cmd-botmaster.rs - Botmaster Commands
*/

+ botmaster login
* ismaster=true => {topic=botmaster}Login successful.
- Login failed. You are not the botmaster.

> topic botmaster

	+ block * from *
	- Blocking {uppercase}<star2>{/uppercase}-{lowercase}<star1>{/lowercase}... &botmaster.block(<star2>,<star1>)

	+ ban * from * for *
	- Banning {uppercase}<star2>{/uppercase}-{lowercase}<star1>{/lowercase}... &botmaster.ban(<star2>,<star1>,<star3>)

	+ reply search *
	- Search &botmaster.search(<star>)

	+ msn load
	- Msn Statistics:\n\n&botmaster.msn()

	+ msn users
	- Msn Users:\n\n&botmaster.msn(users)

	+ idle (on|off)
	- Idle &botmaster.idle(<star>)

	+ debug (on|off)
	- Debug mode &botmaster.debug(<star>)

	+ clear logs
	- Conversation logs &botmaster.clearlogs()

	+ aim crash *
	- &botmaster.aimcrash(<star>)

	+ aim crash us
	- Sending broken <Fontsml=f sml= ></Font>HTML...

	+ reload
	- Reloading bot... &botmaster.reload()

	+ perl
	- Entering Perl evaluator. Enter your expressions and hit "enter."{topic=perl}

	+ quit
	- {topic=random}Logged out.

	+ *
	- Botmaster Commands:\n\n
	^ reload - Reload the bot\n
	^ block [user] from [listener] - Block a user\n
	^ ban [usr] from [lis] for [reason] - Ban a user\n
	^ reply search * - Search the replies\n
	^ msn load - Get MSN statistics\n
	^ idle on|off - Idle Mode\n
	^ debug on|off - Debug Mode\n
	^ clear logs - Clear convo\n
	^ aim crash * - Crash AIM user\n
	^ aim crash us - Crash Yourselves\n
	^ quit - Exit the menu.

< topic

> topic perl

	+ *
	- &perl.evaluate(<id>,<star>)

	+ quit
	- Quitting the Perl evaluator.{topic=random}

< topic