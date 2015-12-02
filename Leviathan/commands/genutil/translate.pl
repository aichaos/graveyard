#      .   .               <Leviathan>
#     .:...::     Command Name // !translate
#    .::   ::.     Description // Google Translator.
# ..:;;. ' .;;:..        Usage // !translate <from>-<to>: <string>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub translate {
	my ($self,$client,$msg) = @_;

	# Emulate your favorite browser.
	my $http_agent = 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; (R1 1.5))';

	# Filter things.
	$msg =~ s/\&lt\;/</ig;
	$msg =~ s/\&gt\;/>/ig;
	$msg =~ s/\&quot\;/"/ig;
	$msg =~ s/\&apos\;/'/ig;
	$msg =~ s/\&amp\;/&/ig;
	$msg =~ s/: /:/g;

	# Get the variables.
	my ($to,$what,$from);
	($to,$what) = split(/:/, $msg, 2);
	($from,$to) = split(/\-/, $to, 2);
	$from = lc($from);
	$to = lc($to);

	# Our language pairs.
	$from = "en" if $from eq "english";
	$from = "de" if $from eq "german";
	$from = "fr" if $from eq "french";
	$from = "es" if $from eq "spanish";
	$from = "it" if $from eq "italian";
	$to = "en" if $to eq "english";
	$to = "de" if $to eq "german";
	$to = "fr" if $to eq "french";
	$to = "es" if $to eq "spanish";
	$to = "it" if $to eq "italian";

	# Get translatin'!
	if (length $from == 2 && length $to == 2 && length $what > 0) {
		use HTTP::Request;
		use LWP::UserAgent;

		# Create a new user agent.
		my $ua = LWP::UserAgent->new;

		# Define the browser emulation.
		$ua->agent ($http_agent);

		# Request Google's translator.
		my $req = HTTP::Request->new (POST => 'http://translate.google.com/translate_t');
		$req->content_type ('application/x-www-form-urlencoded');
		$req->content ("text=$what&langpair=$from|$to");

		# Pass request to the user agent.
		my $res = $ua->request ($req);

		# Check the outcome.
		if ($res->is_success) {
			# Filter the source.
			my $src = $res->content;
			$src =~ s/\n//ig;

			# Get the output.
			if ($src =~ /<textarea name=q rows=5 cols=45 wrap=PHYSICAL>(.*?)<\/textarea>/i) {
				my $out = $1;
				return $out;
			}
			else {
				return "Could not find a response!";
			}
		}
		else {
			return $res->status_line;
		}
	}
	else {
		return "Invalid language. Valid languages are: English, German, French, Spanish, and Italian.\n\n"
			. "Command usage:\n"
			. "!lang from-to: message";
	}
}
{
	Category => 'Utilities',
	Description => 'Google Translator.',
	Usage => '!translate <from>-<to>: <message>',
	Listener => 'All',
};