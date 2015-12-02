#      .   .               <Leviathan>
#     .:...::     Command Name // !news
#    .::   ::.     Description // World News.
# ..:;;. ' .;;:..        Usage // !news
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub news {
	my ($self,$client,$msg) = @_;

	my ($listener,$nick) = split(/\-/, $client, 2);

	# World News Command.
	# Coded by: Cerone Kirsle <kirsle@kirsle.net>
	# Credits:
	#     WiredBots - I used the URL they use because I couldn't find
	#                 any good RSS feeds. :P

	# Start the reply.
	my $reply = ".: World News :.\n\n";

	# Get the news content.
	my $src = LWP::Simple::get "http://www.maximumedge.com/cgi/news/top.txt";
	my @lines = split(/\n/, $src);

	# Go through the source.
	foreach my $line (@lines) {
		my @parts = split(/\|/, $line);

		# Format this for the messengers.
		if ($listener eq "AIM" || $listener eq "HTTP") {
			$reply .= "o <a href=\"http://www.maximumedge.com/cgi/news/article.cgi/$parts[0]\">"
				. "$parts[1]</a>\n";
		}
		else {
			$reply .= "$parts[1]\n"
				. "http://www.maximumedge.com/cgi/news/article.cgi/$parts[0]\n\n";
		}
	}

	# Return the reply.
	return $reply;
}
{
	Category => 'Utilities',
	Description => 'World News.',
	Usage => '!news',
	Listener => 'All',
};