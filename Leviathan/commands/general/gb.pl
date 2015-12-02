#      .   .               <Leviathan>
#     .:...::     Command Name // !gb
#    .::   ::.     Description // View the guestbook!
# ..:;;. ' .;;:..        Usage // !gb
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2005 AiChaos Inc.

sub gb {
	my ($self,$client,$msg) = @_;

	#################################
	### CONFIGURATION PORTION     ###
	#################################

	# Number of entries to show (you may edit if you want):
	my $len = 5;

	# Guestbook entry separator:
	my $sep = "\n\n--------------------\n\n";

	#################################
	### END CONFIGURATION PORTION ###
	#################################

	# Does the guestbook exist?
	if (!-e "./data/guestbook.txt") {
		return "Nobody has signed my guestbook yet. Why not be the first?\n\n"
			. "Type: !sign (message goes here)";
	}

	# Load the book.
	open (GB, "./data/guestbook.txt");
	my @gb = <GB>;
	close (GB);
	chomp @gb;

	# Reverse the book, show the newest entries.
	my @show = reverse @gb;

	# Start the reply.
	my @reply = ();
	my @keep = ();
	for (my $i = 0; $i < $len && defined $show[$i]; $i++) {
		push (@keep, $show[$i]);
		my ($time,$user,$mess) = split(/==/, $show[$i], 3);
		push (@reply, "<lt>$time<gt> $user: $mess");
	}

	# Return the reply.
	return ":: My Guestbook ::\n\n"
		. CORE::join ($sep, @reply);
}

{
	Category => 'General',
	Description => 'View my guestbook!',
	Usage => '!gb',
	Listener => 'All',
};