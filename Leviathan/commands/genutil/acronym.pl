#      .   .               <Leviathan>
#     .:...::     Command Name // !acronym
#    .::   ::.     Description // Acronym Finder.
# ..:;;. ' .;;:..        Usage // !acronym
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub acronym {
	my ($self,$client,$msg) = @_;

	# Make sure there's a message.
	if (length $msg > 0) {
		# No spaces allowed, only letters/numbers.
		if ($msg =~ /[^A-Za-z0-9]/i) {
			return "An acronymn consists of only letters and numbers.";
		}

		$msg = uc($msg);

		# User Agent.
		my $agent = 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; (R1 1.5))';

		# Modules....
		use HTTP::Request;
		use LWP::UserAgent;

		# Create a new agent.
		my $ua = LWP::UserAgent->new;

		# Emulate IE.
		$ua->agent ($agent);

		# Get the acronym finder.
		my $req = HTTP::Request->new (GET => "http://www.acronymfinder.com/af-query.asp?String=exact&Acronym=$msg");
		my $res = $ua->request ($req);
		my $src = $res->content;

		# Get the most common result.
		$src =~ s/\n//g;

		if ($src =~ /<td valign=\"middle\" width=\"15\%\" bgcolor=\"white\"><b>$msg<\/b><\/td>(.*?)<td valign=\"middle\" width=\"75\%\" bgcolor=\"white\"><b>(.*?)<\/b>/i) {
			my $acronym = $2;
			return "</b>The most common acronym for <b>$msg</b> is <b>$acronym</b>.";
		}

		return "Could not find a result for that acronym.";
	}
	else {
		return "Give me an acronym to look up!\n\n"
			. "Ex:\n"
			. "!acronym HTML";
	}
}
{
	Category => 'Utilities',
	Description => 'Acronym Finder.',
	Usage => '!acronym <acronym>',
	Listener => 'All',
};