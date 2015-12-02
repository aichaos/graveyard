# loadBrains.pl - load the bot's brain.

sub loadBrains {
	# Create the bot brain.
	$aiden->{rive} = new RiveScript (debug => 0);

	print "Debug // Loading brains:\n"
		. "\tFrom: $root->{replies}\n\n" if $aiden->{debug};

	$aiden->{rive}->loadDirectory ($aiden->{root}->{replies},'.rs');
	$aiden->{rive}->sortReplies();

	open (DEBUG, ">./debug.txt");
	use Data::Dumper;
	print DEBUG Dumper($aiden->{rive});
	close (DEBUG);
}
1;