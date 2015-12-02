#      .   .		   <Leviathan>
#     .:...::	  Command Name // !weather
#    .::   ::.	   Description // Get U.S. Weather
# ..:;;. ' .;;:..	 Usage // !weather <zip code>
#    .	'''  .	   Permissions // Public
#     :;,:,;:	      Listener // All
#     :     :	     Copyright // 2005 AiChaos Inc.

sub weather {
	my ($self,$client,$msg) = @_;

	if ($msg =~ /[^0-9]/ || length $msg != 5) {
		return "Use a valid zip code when calling this command.\n\n"
			. "Example:\n"
			. "!weather 90210";
	}

	# Get weather.com's information.
	use HTTP::Request;
	use LWP::UserAgent;

	my $agent = 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; (R1 1.5))';

	# Set up UserAgent.
	my $ua = LWP::UserAgent->new;
	$ua->agent ($agent);

	# Make the request.
	my $req = HTTP::Request->new (GET => "http://www.weather.com/weather/local/$msg?lswe=$msg&lwsa=WeatherLocalUndeclared");
	my $res = $ua->request ($req);

	# Success?
	if ($res->is_success) {
		# Filter the source.
		my $src = $res->content;
		$src =~ s/\n//g;

		my %data = (
			city     => '',
			weather  => '(unknown conditions)',
			temp     => '?',
			feel     => '?',
			uv       => 'undefined',
			wind     => 'undefined',
			humidity => 'undefined',
			pressure => 'undefined',
			dew      => 'undefined',
			vis      => 'undefined',
		);
		if ($src =~ /<B>Right Now For<\/B><BR>(.*?) \($msg\)<BR>/i) {
			$data{city} = $1;
		}
		if ($src =~ /<BR><B class=obsTextA>(.*?)<\/B><\/TD>/i) {
			$data{weather} = $1;
		}
		if ($src =~ /<B class=obsTempTextA>(\d*?)\&deg\;F<\/B>/i) {
			$data{temp} = $1;
		}
		if ($src =~ /<B CLASS=obsTextA>Feels Like<BR> (\d*?)\&deg\;F<\/B>/i) {
			$data{feel} = $1;
		}
		if ($src =~ />UV Index:<\/td>(.*?)CLASS=\"obsTextA\">(.*?)<\/td>/i) {
			$data{uv} = $2;
		}
		if ($src =~ />Wind:<\/td>(.*?)CLASS=\"obsTextA\">(.*?)<\/td>/i) {
			$data{wind} = $2;
		}
		if ($src =~ />Humidity:<\/td>(.*?)CLASS=\"obsTextA\">(.*?)<\/td>/i) {
			$data{humidity} = $2;
		}
		if ($src =~ />Pressure:<\/td>(.*?)CLASS=\"obsTextA\">(.*?)(\t|\s)+<IMG/i) {
			$data{pressure} = $2;
		}
		if ($src =~ />Dew Point:<\/td>(.*?)CLASS=\"obsTextA\">(.*?)<\/td>/i) {
			$data{dew} = $2;
		}
		if ($src =~ />Visibility:<\/td>(.*?)CLASS=\"obsTextA\">(.*?)<\/td>/i) {
			$data{vis} = $2;
		}

		# Filtering.
		foreach my $key (keys %data) {
			$data{$key} =~ s/\&deg\;/ °/g;
			$data{$key} =~ s/\&nbsp\;/ /g;
			$data{$key} =~ s/<br>/\;/ig;
		}

		return ":: Weather ::\n\n"
			. "$data{city} ($msg)\n"
			. "$data{weather}\n\n"
			. "Temperature: $data{temp} °F\n"
			. "Feels Like: $data{feel} °F\n"
			. "UV Index: $data{uv}\n"
			. "Wind: $data{wind}\n"
			. "Humidity: $data{humidity}\n"
			. "Pressure: $data{pressure}\n"
			. "Dew Point: $data{dew}\n"
			. "Visibility: $data{vis}";
	}
	else {
		return $res->status_line;
	}
}
{
	Category    => 'Utilities',
	Description => 'Get U.S. Weather',
	Usage       => '!weather <zip code>',
	Listener    => 'All',
};
