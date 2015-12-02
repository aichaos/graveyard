#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !weather
#    .::   ::.     Description // Get local weather forecast.
# ..:;;. ' .;;:..        Usage // !weather <zip code or city/state>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub weather {
	# Get variables from the shift.
	my ($self,$client,$msg,$listener) = @_;

	# Weather Forecast Command: Get Your Forecast from Yahoo! Weather
	# Created by: Cerone Kirsle <kirsle@kirsle.net>
	# Credits:
	#     Keenie - told me that (.*?) narrows down the matching possibilities (very useful)
	# If you use this command or convert it, please keep this credit comment
	# perfectly intact. I did a lot of work on this so you should at least give
	# me a little credit. The bot will in no way tell your users who made it, so
	# what's this comment going to hurt? Thanks! :)

	# Make sure they have a valid area code.
	if ($msg) {
		# Get the weather from weather.com!
		my $url = "http://weather.yahoo.com/search/weather2?p=$msg";
		my $src = get "$url" or return "Could not load URL $url!";

		# Go through the source.
		$src =~ s/\n//g;

		# Save it to a text file and launch Notepad to view it.
		#open (SRC, ">F:/yahooweather.txt");
		#print SRC $src;
		#close (SRC);
		#system ("F:/WINDOWS/Notepad.exe F:/yahooweather.txt");

		my ($locale,$bar,$temp,$feel,$wind,$dew,$humid,$vis,$pressure,$sunrise,$sunset);
		if ($src =~ /<title>yahoo\! weather - (.*?) <\/title>/i) {
			$locale = $1;
		}
		if ($src =~ /company to work for\? -->(.*?)<\!-- testasdf -->/i) {
			$temp = $1;
		}
		if ($src =~ /feels like:<\/b><\/font><\/td><td><font face=arial size=2>(.*?)<\/font>/i) {
			$feel = $1;
		}
		if ($src =~ /dewpoint:<\/b><\/font><\/td><td><font face=arial size=2>(.*?)<\/font>/i) {
			$dew = $1;
		}
		if ($src =~ /wind:<\/b><\/font><\/td><td><font face=arial size=2>(.*?)<\/font>/i) {
			$wind = $1;
		}
		if ($src =~ /sunrise:<\/b><\/font><\/td><td><font face=arial size=2>(.*?)<\/font>/i) {
			$sunrise = $1;
		}
		if ($src =~ /sunset:<\/b><\/font><\/td><td><font face=arial size=2>(.*?)<\/font>/i) {
			$sunset = $1;
		}
		if ($src =~ /humidity:<\/b><\/font><\/td><td><font face=arial size=2>(.*?)<\/font>/i) {
			$humid = $1;
		}
		if ($src =~ /visibility:<\/b><\/font><\/td><td><font face=arial size=2>(.*?)<\/font>/i) {
			$vis = $1;
		}
		if ($src =~ /barometer:<\/b><\/font><\/td><td><font face=arial size=2>(.*?)<\/font>/i) {
			$bar = $1;
		}

		# Get the forecasts.
		my ($today,$tonight,$tomorrow);
		if ($src =~ /today:<\/b>(.*?)<p>/i) {
			$today = $1;
		}
		if ($src =~ /tonight:<\/b>(.*?)<p>/i) {
			$tonight = $1;
		}
		if ($src =~ /tomorrow:<\/b>(.*?)<p>/i) {
			$tomorrow = $1;
		}
	

		return "Forecast for $locale ($msg)\n\n"
			. "Temperature: $temp\n"
			. "Feels Like: $feel\n"
			. "Barometer: $bar\n"
			. "Humidity: $humid\n"
			. "Visibility: $vis\n"
			. "Dew Point: $dew\n"
			. "Wind: $wind\n"
			. "Sunrise: $sunrise\n"
			. "Sunset: $sunset\n\n"
			. "(*) Today: $today\n"
			. "(*) Tonight: $tonight\n"
			. "(*) Tomorrow: $tomorrow";
	}
	else {
		return "Enter your Zip Code!\n\n"
			. "!weather 48502";
	}
}

{
	Category => 'General Utilities',
	Description => 'Your Weather Forecast',
	Usage => '!weather <zip code or city>',
	Listener => 'All',
};