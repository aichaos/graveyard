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
# HTTP Handler: receive
#  Description: Checks for requests on the HTTP daemon.

sub http_receive {
	my ($http) = @_;

	# Header types.
	my %head = ();
	$head{html} = new HTTP::Headers (Content_Type => 'text/html');
	$head{txt}  = new HTTP::Headers (Content_Type => 'text/plain');

	# Get the daemon reference.
	my $d = $chaos->{bots}->{$http}->{client};

	# Check for requests.
	my $c = $d->accept || return;

	# Get the client's IP address.
	my $ip = $c->peerhost;

	# Get the request.
	my $r = $c->get_request;
	if (defined $r) {
		# Only support the GET method.
		if ($r->method eq 'GET') {
			# The path requested.
			my $path = $r->url->path;

			# Query string.
			my $query = $r->url->query;

			# Go through the query string.
			my %in = ();
			my @pairs = split(/\&/, $query) if defined $query;
			foreach my $pair (@pairs) {
				my ($what,$is) = split(/=/, $pair, 2);
				$what = lc($what);
				$what =~ s/ //g;

				# Change pluses to spaces.
				$is =~ s/\+/ /g;
				$is =~ s/   / + /g;

				# URI Escaping.
				$is = uri_unescape ($is);
				$is =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;

				# Save this.
				$in{$what} = $is;
			}

			# Log this.
			my $stamp = &timestamps ('local','<month_num>-<day_month>-<year_short> @ <hour_24>:<min>:<secs>');
			open (LOG, ">>./logs/http_access.txt");
			print LOG "$stamp - $ip GET $path";
			print LOG "?$query" if defined $query;
			print LOG "\n";
			close (LOG);

			# Go through the "wanted" actions.
			if ($path eq '/') {
				# Give the index.
				$c->send_file_response ("./server/index.html");
			}
			elsif ($path eq '/chat.html') {
				# If they're sending a message...
				my $reply;
				if (length $in{msg} > 0) {
					# Call the HTTP IM handler.
					$reply = &http_im_in ($http,$ip,$in{msg});
				}
				else {
					# Greet them.
					$in{msg} = "CONNECT";
					$reply = "Hello there $ip and thanks for connecting!";
				}

				# Load the reply page.
				open (SRC, "./server/chat.html");
				my @src = <SRC>;
				close (SRC);
				chomp @src;
				my @print = ();

				# Filter in the data.
				foreach my $line (@src) {
					$line =~ s/<client>/$ip/ig;
					$line =~ s/<bot>/$chaos->{bots}->{$http}->{nick}/ig;
					$line =~ s/<msg>/$in{msg}/ig;
					$line =~ s/<reply>/$reply/ig;

					# Format spaces.
					$line =~ s/  / &nbsp;/ig;

					push (@print, $line);
				}

				# Prepare the response.
				my $html = CORE::join ("\n", @print);
				my $resp = new HTTP::Response (undef, undef, $head{html}, $html);

				# Send it.
				$c->send_response ($resp);
			}
			elsif ($path =~ /^\/docs/i) {
				# (Re) format the path.
				my $docs = $path;
				$docs =~ s/^\/docs//ig;

				if ($path eq '/docs') {
					$c->send_redirect ("http://$http/docs/index.html");
				}
				else {
					# Index?
					if ($docs eq '/') {
						$c->send_file_response ("./docs/index.html");
					}
					else {
						# If exists...
						if (-e "./docs" . $docs) {
							$c->send_file_response ("./docs" . $docs);
						}
						else {
							# 404 Error.
							$c->send_file_response ("./server/404.html");
						}
					}
				}
			}
			elsif ($path =~ /^\/logs/i) {
				# Only if the botmaster wants it.
				if ($chaos->{config}->{http_logs} == 1) {
					# Redirect to the "logs" directory.
					my $logs = $path;
					$logs =~ s/^\/logs//ig;

					if ($path eq '/logs') {
						$c->send_redirect ("http://$http/logs/chat/convo.html");
					}
					else {
						# Index?
						if ($logs eq '/') {
							$c->send_file_response ("./logs/chat/convo.html");
						}
						else {
							# If it exists...
							if (-e "./logs" . $logs) {
								$c->send_file_response ("./logs" . $logs);
							}
							else {
								# 404 Error.
								$c->send_file_response ("./server/404.html");
							}
						}
					}
				}
				else {
					$c->send_file_response ("./server/403logs.html");
				}
			}
			elsif ($path eq '/stats.txt') {
				# Get statistics.
				my @stats = &statistics ();

				# Prepare the response.
				my $html = CORE::join ("\n", @stats);
				my $resp = new HTTP::Response (undef, undef, $head{html}, $html);

				# Send it.
				$c->send_response ($resp);
			}
			elsif ($path eq '/blocked.cgi') {
				# Checking a blocked user.
				if (defined $in{user}) {
					# See if they're blocked.
					my ($blocked,$reason) = &isBlocked($in{user});
					$reason = 'not blocked' unless defined $reason;

					# Prepare the response.
					my $html = "$blocked $reason";
					my $resp = new HTTP::Response (undef, undef, $head{html}, $html);

					# Send it.
					$c->send_response ($resp);
				}
				else {
					$c->send_redirect ("http://$http/");
				}
			}
			elsif ($path eq '/warner.cgi') {
				# Checking a warner.
				if (defined $in{user}) {
					# See if they're a warner.
					my $warner = &isWarner($in{user});

					# Prepare the response.
					my $html = $warner;
					my $resp = new HTTP::Response (undef, undef, $head{html}, $html);

					# Send it.
					$c->send_response ($resp);
				}
				else {
					$c->send_redirect ("http://$http/");
				}
			}
			else {
				# Don't allow hacking.
				if ($path =~ /\.\./) {
					$c->send_file_response ("./server/403.html");
				}
				else {
					# See if the file exists.
					if (-e "./server" . $path) {
						$c->send_file_response ("./server" . $path);
					}
					else {
						$c->send_file_response ("./server/404.html");
					}
				}
			}
		}
	}

	undef $c; # Close the connection.

	# Return.
	return 1;
}
{
	Type        => 'handler',
	Name        => 'http_receive',
	Description => 'Receives HTTP requests.',
	Author      => 'Cerone Kirsle',
	Created     => '2:46 PM 12/8/2004',
	Updated     => '2:46 PM 12/8/2004',
	Version     => '1.0',
};