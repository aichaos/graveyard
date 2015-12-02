# Graveyard

This is where legacy old chatbots, which may or may not (probably not) work
anymore, go to die.

This is a collection of old archived chatbot projects from circa 2003 from the
old AiChaos website.

For the most part each bot is left intact from its final release version, with
maybe some log files or such cleaned up.

All of these bots were released under the **GNU General Public License**
version 2.

# AiChaos Legacy Bots

In as close to chronological order as I can remember, here's information about
the old legacy AiChaos chatbot platforms.

## [ChaosBot](./ChaosBot)

This was a learning chatbot which learns how to chat by chatting with people.
The mechanism is pretty simple and works like this:

1. Bot's brain is empty; its first user says "hello"
2. Bot doesn't know an answer for that, and repeats the user instead.
3. User now says "how are you?"
4. Bot doesn't know the answer to that, either, **but** it logs internally that
   "how are you?" is a valid follow-up question for "hello". For now it just
   repeats the user's message, again.
5. A second user says "hello" to the bot. The bot knows that "how are you?" is
   a valid follow-up question to "hello", and it says "how are you?" to the
   second user.

This system worked okay with only a single user using the bot, but it falls
apart quickly when unleashed on the general Internet.

* Date: 2002-04
* Final version: 1.0.00
* Supported chat platforms:
  * AOL Instant Messenger
  * MSN Messenger
* Supported brains:
  * Custom learning brain

## [NexusBot](./NexusBot)

Nexus was a learning chatbot similar to Chaosbot. I don't remember what the
difference in algorithm is, if any.

It had several levels of user access control: moderator, supermoderator,
admin, superadmin, and master. It had a pluggable command system, but commands
weren't auto-discoverable like they are in the Juggernaut and Leviathan bots.

* Date: 2002-04
* Final version: 1.0.00
* Supported chat platforms:
  * AOL Instant Messenger
  * MSN Messenger
  * HTTP daemon
* Supported brains:
  * Nexus: custom learning brain like Chaosbot

## [AiChaos Juggernaut](./Juggernaut)

Juggernaut was a monolithic chatbot that connects to multiple chat platforms,
supports multiple brain back-ends, and has a pluggable commands system with
automatic discovery (commands are self-documenting and registered
automatically).

It comes with dozens of commands, including random games, a primitive currency
system, lots of random reply generators, weather lookup, etc.

It supports multiple layers of user authentication: moderators, administrators,
and botmasters (super-admins).

It also includes a graphical front-end written in Perl/Tk.

* Date: 2004
* Final version: 4.0
* Supported chat platforms:
  * AOL Instant Messenger
  * MSN Messenger
  * IRC
  * HTTP daemon
* Supported brains:
  * ChaosML (custom reply language; AIML-like; ancestor to RiveScript)
  * Juggernaut (seems to be similar to ChaosML)
  * Nexus (an evolved version of the NexusBot brain)
  * ELIZA (via [Chatbot::Eliza](http://search.cpan.org/perldoc?Chatbot::Eliza))

## [AiChaos Leviathan](./Leviathan)

Leviathan was the successor to Juggernaut and contains most of the same
features. It was a rewrite from the ground up using lessons learned from
developing Juggernaut, and it supports even more brain back-ends including
an experimental successor to the NexusBot brain named Rive (not to be confused
with RiveScript).

An older release of Leviathan included a Perl/Tk GUI, but version 2.0 does not.

* Date: April 20, 2006
* Final version: 2.0
* Supported chat platforms:
  * AOL Instant Messenger
  * MSN Messenger
  * IRC
  * CyanChat
  * XMPP
  * SMTP daemon (needs to listen on port 25)
  * HTTP daemon
* Supported brains:
  * [Chatbot::Alpha](http://search.cpan.org/perldoc?Chatbot::Alpha) -
    the direct predecessor to RiveScript.
    * Personalities: Alice, Standard, Casey, Cody, Chaos
  * ChaosML
  * ELIZA (via [Chatbot::Eliza](http://search.cpan.org/perldoc?Chatbot::Eliza))
  * Guardians (a utilitarian "brain"... it was used purely for monitor bots
    that would add other bots (or users) to their buddy list and monitor online
    status/uptime).
  * Juggernaut
  * Nexus
  * Rive (a successor to Nexus which tagged learned information with the user
    ID, to make moderation and cleanup easier; not to be confused with
    RiveScript).

## [AiChaos Aiden](./Aiden)

Aiden was the successor to Leviathan and was mostly for my own use. It doesn't
include a lot of the documentation, bundled dependencies, easy configuration
formats, or general user-friendliness of previous AiChaos bots.

It doesn't include much user-access control except for a Botmaster role, with a
small set of related commands that can be used. The botmaster commands were
implemented via a standard RiveScript Perl object macro.

* Final version: 1.0
* Supported chat platforms:
  * AOL Instant Messenger
  * MSN Messenger
  * Yahoo! Messenger
  * HTTP daemon
* Supported brains:
  * RiveScript
