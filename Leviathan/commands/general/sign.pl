#      .   .               <Leviathan>
#     .:...::     Command Name // !sign
#    .::   ::.     Description // Sign the guestbook!
# ..:;;. ' .;;:..        Usage // !sign <message>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2005 AiChaos Inc.

sub sign {
	my ($self,$client,$msg) = @_;

	# Needs a message.
	return "When you use this command, also send a message to leave in the guestbook! (note: "
		. "anything vulgar may get you blocked!)\n\n"
		. "!sign message to sign into the book" unless length $msg > 0;

	# Get timestamp.
	my $time = &timestamps ('local', 'm{on}-dd-yy @ hh:mm:ss');

	# Chop the message.
	$msg =~ s/\n//g;
	$msg =~ s/\r//g;

	# Does the book exist?
	if (-e "./data/guestbook.txt") {
		# Add to the end.
		open (APPEND, ">>./data/guestbook.txt");
		print APPEND "\n"
			. "$time==$client==$msg";
		close (APPEND);
	}
	else {
		# Create the first entry.
		open (FIRST, ">./data/guestbook.txt");
		print FIRST "$time==$client==$msg";
		close (FIRST);
	}

	return "Your message has been added to the guestbook. Type !gb to see the guestbook.";
}

{
	Category => 'General',
	Description => 'Sign my guestbook!',
	Usage => '!sign <message>',
	Listener => 'All',
};