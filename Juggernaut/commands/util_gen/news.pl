#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !news
#    .::   ::.     Description // Get up-to-date world news.
# ..:;;. ' .;;:..        Usage // !news
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub news {
	my ($self,$client,$msg,$listener) = @_;

	# World News Command.
	# Coded by: Cerone Kirsle <kirsle@kirsle.net>
	# Credits:
	#     WiredBots - I used the URL they use because I couldn't find
	#                 any good RSS feeds. :P

	# Start the reply.
	my $reply = ".: World News :.\n\n";

	# Get the news content.
	my $src = get "http://www.maximumedge.com/cgi/news/top.txt";
	my @lines = split(/\n/, $src);

	# Go through the source.
	foreach my $line (@lines) {
		my @parts = split(/\|/, $line);

		# Format this for AIM or MSN.
		if ($listener eq "MSN") {
			$reply .= "$parts[1]\n"
				. "http://www.maximumedge.com/cgi/news/article.cgi/$parts[0]\n\n";
		}
		else {
			$reply .= "o <a href=\"http://www.maximumedge.com/cgi/news/article.cgi/$parts[0]\">"
				. "$parts[1]</a>\n";
		}
	}

	# Return the reply.
	return $reply;
}

{
	Category => 'General Utilities',
	Description => 'World News',
	Usage => '!news',
	Listener => 'All',
};