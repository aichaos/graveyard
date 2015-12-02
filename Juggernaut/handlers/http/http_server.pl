#              ::.                   .:.
#               .;;:  ..:::::::.  .,;:
#                 ii;,,::.....::,;;i:
#               .,;ii:          :ii;;:
#             .;, ,iii.         iii: .;,
#            ,;   ;iii.         iii;   :;.
# .         ,,   ,iii,          ;iii;   ,;
#  ::       i  :;iii;     ;.    .;iii;.  ,,      .:;
#   .,;,,,,;iiiiii;:     ,ii:     :;iiii;;i:::,,;:
#     .:,;iii;;;,.      ;iiii:      :,;iiiiii;,:
#          :;        .:,,:..:,,.        .:;..
#           i.                  .        ,:
#           :;.         ..:...          ,;
#            ,;.    .,;iiiiiiii;:.     ,,
#             .;,  :iiiii;;;;iiiii,  :;:
#                ,iii,:        .,ii;;.
#                ,ii,,,,:::::::,,,;i;
#                ;;.   ...:.:..    ;i
#                ;:                :;
#                .:                ..
#                 ,                :
# HTTP Handler: http_server
#  Description: Runs the HTTP server.

sub http_server {
	my ($host,$port,$name,$brain,$reply,$data) = @_;

	print "http_server called!\n";

	while (1) {
		print "HTTP loop (fake)\n";
	}

	# Chaos AI Technology Juggernaut Server
	use lib "./lib";

	# URI Characters to escape.
	my %uri = (
		"\%20" => " ",
		"\%21" => "\!",
		"\%22" => "\"",
		"\%23" => "\#",
		"\%24" => "\$",
		"\%25" => "\%",
		"\%26" => "\&",
		"\%27" => "\'",
		"\%28" => "\(",
		"\%29" => "\)",
		"\%2A" => "\*",
		"\%2B" => "\+",
		"\%2C" => "\,",
		"\%2D" => "\-",
		"\%2E" => "\.",
		"\%2F" => "\/",
		"\%3A" => "\:",
		"\%3B" => "\;",
		"\%3C" => "\<",
		"\%3D" => "\=",
		"\%3E" => "\>",
		"\%3F" => "\?",
		"\%40" => "\@",
		"\%5B" => "\[",
		"\%5C" => "\\",
		"\%5D" => "\]",
		"\%5E" => "\^",
		"\%5F" => "\_",
		"\%60" => "\`",
		"\%7B" => "\{",
		"\%7C" => "\|",
		"\%7D" => "\}",
		"\%7E" => "\~",
	);

	# Use HTTP modules to startup the server.
	use HTTP::Daemon;
	use HTTP::Status;
	use strict;
	use warnings;
	use URI::Escape;
	use LWP::Simple;

	# Use Sys::HostIP to get our local IP address.
	use Sys::HostIP;

	# Get our IP.
	my $ip_address = Sys::HostIP->ip;

	# Declare the chaos hash.
	my $chaos = {};

	# Common variables.
	my ($line,$item,@data,$what,$is,$lvl,$result,$file,$c,$ip,$r,@pairs,$pair,
		$key,%in,$wanted,$active,$query);

	# Make sure we have all the required directories.
	my @required_directories = (
		"./bots",
		"./brains",
		"./clients",
		"./commands",
		"./config",
		"./data",
		"./handlers/aim",
		"./handlers/msn",
		"./handlers/http",
		"./lib",
		"./logs",
		"./settings",
		"./subroutines",
	);
	foreach $item (@required_directories) {
		if (-e $item == 0) {
			&panic ("You are missing required directory $item.", 1);
		}
	}

	# Load the configuration data.
	print ":: Loading Configuration \"startup.cfg\"... ";
	open (STARTUP, "./config/startup.cfg");
	@data = <STARTUP>;
	close (STARTUP);
	chomp @data;
	foreach $line (@data) {
		($what,$is) = split(/=/, $line, 2);
		$what = lc($what);
		$what =~ s/ //g;
		$chaos->{_system}->{config}->{$what} = $is;
	}
	print "Done!\n";

	# Load the substitution data.
	print ":: Loading Configuration \"substitution.cfg\"... ";
	open (SUBS, "./config/substitution.cfg");
	@data = <SUBS>;
	close (SUBS);
	chomp @data;
	foreach $line (@data) {
		($lvl,$what,$is) = split(/==/, $line, 3);
		$what = lc($what);
		$chaos->{_system}->{substitution}->{$what}->{level} = $lvl;
		$chaos->{_system}->{substitution}->{$what}->{replace} = $is;
	}
	print "Done!\n";

	# Make use of the local library.
	print ":: Loading Local Library... Done!\n";

	# Load all sub files.
	print ":: Loading Perl Files...\n";
	my @perl_files = (
		"./brains",
		"./handlers/aim",
		"./handlers/msn",
		"./handlers/http",
		"./settings",
		"./subroutines",
	);
	foreach $item (@perl_files) {
		opendir (PL, $item);
		foreach my $file (sort(grep(!/^\./, readdir (PL)))) {
			print "\tIncluding $item/$file...\n";
			require "$item/$file";
		}
		closedir (PL);
	}

	# Load the reply data.
	print ":: Loading Reply Data... ";
	&load_replies("_http",$chaos->{_system}->{server}->{brain},$chaos->{_system}->{server}->{reply});
	print "Done!\n";

	# Save the data in a more local location.
	$chaos->{_http}->{brain} = $brain;
	$chaos->{_http}->{reply} = $reply;

	# Get a list of things in the commands folder.
	print ":: Indexing Commands... ";
	&load_commands();
	print "Done!\n";

	# Load userdata.
	print ":: Loading Userdata... ";
	&load_data();
	print "Done!\n";

	# Clear out our temp folder of anything that may have survived.
	print ":: Clearing Temporary Files... ";
	opendir (TEMP, "./data/temp");
	foreach $file (sort(grep(!/^\./, readdir (TEMP)))) {
		# Delete the file.
		unlink ("./data/temp/$file");
	}
	closedir (TEMP);
	opendir (HTML, "./server/temp");
	foreach $file (sort(grep(!/^\./, readdir (HTML)))) {
		unlink ("./server/temp/$file");
	}
	closedir (HTML);
	print "Done!\n";

	if ($ip_address ne $host) {
		$ip_address = $host;
	}

	my $server_addr = "http://" . $ip_address . ":" . $chaos->{_system}->{server}->{serverport} . "/";

	# Start the Daemon.
	my $d = new HTTP::Daemon (
		LocalHost => $chaos->{_system}->{server}->{serverhost},
		LocalPort => $chaos->{_system}->{server}->{serverport},
	);
	print "CKS // Your bot is running at <URL:" . $server_addr . "> \n\n";

	# Globals for later.
	while ($c = $d->accept) {
		# Get the client"s IP address.
		$ip = $c->peerhost;

		$r = $c->get_request;
		if ($r) {
			if ($r->method eq "GET") {
				$wanted = $r->url->path;

				$query = $r->url->query;

				# Go through the query string.
				@pairs = split(/\&/, $query);
				foreach $pair (@pairs) {
					($what,$is) = split(/=/, $pair, 2);
					$what = lc($what);
					$what =~ s/ //g;

					# Change pluses to spaces.
					$is =~ s/\+/ /g;
					$is =~ s/   / + /g;

					# URI-Escape the query.
					$query = uri_unescape ($query);

					# Further URI escaping.
					foreach $key (%uri) {
						if (length $key > 0 && length $uri{$key} > 0) {
							$is =~ s/$key/$uri{$key}/ig;
						}
					}

					$in{$what} = $is;
				}

				if ($wanted eq "/") {
					$c->send_file_response ("./server/index.html");
				}
				elsif ($wanted eq "/chat.html") {
					# If they"re sending a message...
					if (length $in{msg} > 0) {
						# Call the HTTP IM handler.
						$reply = http_im_in ($ip,$in{msg});
					}
					else {
						$in{msg} = "CONNECT";
						$reply = "Hello there $ip and thanks for connecting!";
					}

					# Format the reply.
					$reply =~ s/size=\"10\"/size="2"/ig;
					$reply =~ s/color=\"\#000000\"/color="#FFFFFF"/ig;
					$reply =~ s/color=\"black\"/color="#FFFFFF"/ig;

					# Load the reply page.
					open (REPLY, "./server/chat.html");
					@data = <REPLY>;
					close (REPLY);

					chomp @data;

					$result = "";
					foreach $line (@data) {
						# Filter in special tags.
						$line =~ s/<nick>/$ip/ig;
						$line =~ s/<bot>/$chaos->{_system}->{server}->{botname}/ig;
						$line =~ s/<msg>/$in{msg}/ig;
						$line =~ s/<reply>/$reply/ig;

						# Format spacings.
						$line =~ s/  / &nbsp;/ig;

						$result .= "$line\n";
					}

					# Save this result.
					open (NEW, ">./server/html-chat.tmp");
					print NEW $result;
					close (NEW);

					# Send the file.
					$c->send_file_response ("./server/html-chat.tmp");
				}
				elsif ($wanted eq "/status.gif" || $wanted eq "/status.jpg" || $wanted eq "/status.png") {
					# This is for seeing the bot"s online status via images.

					# Open the last active file.
					open (ACTIVE, "./data/active.dat") or $c->send_file_response ("./server/status/offline.gif");
					$active = <ACTIVE>;
					close (ACTIVE);

					# Only show ONLINE if in the last 120 seconds.
					if (time - $active <= 120) {
						$c->send_file_response ("./server/status/online.gif");
					}
					else {
						$c->send_file_response ("./server/status/offline.gif");
					}
				}
				else {
					if (-e "./server" . $wanted == 1) {
						$c->send_file_response ("./server" . $wanted);

						# If this was from the HTML Test command.
						if ($wanted =~ /^\/temp\/(.*?).html$/i) {
							# Delete this file now.
							unlink ("./server/temp/$1.html");
						}
					}
					else {
						$c->send_file_response ("./server/404.html");
					}
				}
			}
		}
		$in{msg} = "";
		$c = undef; # Close connection
	}
}
1;