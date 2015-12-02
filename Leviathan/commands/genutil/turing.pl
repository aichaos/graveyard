#      .   .               <Leviathan>
#     .:...::     Command Name // !turing
#    .::   ::.     Description // Random Turing Test questions.
# ..:;;. ' .;;:..        Usage // !turing
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub turing {
	my ($self,$client,$msg) = @_;

	# Get the page.
	my $src = LWP::Simple::get "http://www.badpen.com/turing/search.php?lu=random&limit=5"
		or return "Error: could not access resource!";
	my @lines = split(/\n/, $src);
	$src =~ s/\n//g;

	# Number of items.
	my $total = '???';
	if ($src =~ /Current number of questions asked : <(.*?)>(\d*?)<\/a><br>/i) {
		$total = $2;
	}

	my @results = ();
	foreach my $line (@lines) {
		chomp $line;
		if ($line =~ /^<li>(\d*?) : (.*?)$/i) {
			push (@results, "$1 : $2");
		}
	}

	unless (@results) {
		return "I could not find the data! Sorry! :-(";
	}

	return "Random 5 Turing Test Questions\n"
		. "(out of $total total)\n\n"
		. CORE::join ("\n", @results);
}
{
	Category => 'Utilities',
	Description => 'Random Turing Test Questions.',
	Usage => '!turing',
	Listener => 'All',
};