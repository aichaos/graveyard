# HTTP Handler: http_request

sub http_request {
	my $bot = shift;

	# Get the client's request.
	my $c = $aiden->{bots}->{$bot}->{client}->accept || return;

	# Define headers.
	my %head = ();
	$head{html} = new HTTP::Headers (Content_Type => 'text/html');
	$head{txt}  = new HTTP::Headers (Content_Type => 'text/plain');

	# Get the client's IP.
	my $ip = $c->peerhost;

	# Get the request.
	my $r = $c->get_request;
	if (defined $r) {
		# Only support GET method.
		if ($r->method eq 'GET') {
			# Get the requested path.
			my $path = $r->url->path;

			# Query string.
			my $query = $r->url->query;

			# Go through the query string.
			my %in = ();
			my @pairs = split(/\&/, $query) if defined $query;
			foreach my $pair (@pairs) {
				my ($what,$is) = split(/=/, $pair, 2);
				$what = lc($what); $what =~ s/ //g;

				$is =~ s/\+/ /g;
				$is =~ s/   / + /g;

				# URI Escaping.
				$is = uri_unescape ($is);

				# Save.
				$in{$what} = $is;
			}

			# Log this HTTP access.
			my $stamp = time_format ('mm{on}-dd-yy @ HH:mm{in}:ss');
			open (LOG, ">>./logs/http_access.txt");
			print LOG "$stamp - $ip GET $path";
			print LOG "?$query" if defined $query;
			print LOG "\n";
			close (LOG);

			# Go through the requests.
			if ($path eq '/') {
				# Give the index page.
				$c->send_file_response ("./server/index.html");
			}
			elsif ($path eq '/dp.jpg') {
				# Send the MSN dp.
				$c->send_file_response ($aiden->{bots}->{$bot}->{displaypic});
			}
			elsif ($path eq '/chat.html') {
				# Chatting.
				my $msg = 'connect';
				$msg = $in{msg} if defined $in{msg};

				my $client = join ('-','HTTP',$ip);

				# Get a reply.
				my $reply = "Hello there $ip and thanks for connecting!";
				if ($msg ne 'connect') {
					$reply = &on_im ('HTTP',undef,$client,$msg,$bot);
				}

				# Get the template.
				open (PAGE, "./server/chat.html");
				my @page = <PAGE>;
				close (PAGE);
				chomp @page;

				my @new = ();
				foreach my $line (@page) {
					$line =~ s/\$user/$ip/ig;
					$line =~ s/\$msg/$msg/ig;
					$line =~ s/\$bot/$aiden->{bots}->{$bot}->{nick}/ig;
					$line =~ s/\$reply/$reply/ig;
					$line =~ s/  / &nbsp;/ig;

					push (@new,$line);
				}

				# Prepare the response.
				my $html = join ("\r\n",@new);
				my $resp = new HTTP::Response (undef,undef,$head{html},$html);

				# Send it.
				$c->send_response ($resp);
			}
			else {
				# If it exists...
				if ($path =~ /\.\./) {
					$c->send_response ('403');
				}
				else {
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

	undef $c;
}

1;