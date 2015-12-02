#!/usr/bin/perl

# Chaos AI Technology ChaosBot Server

# Use HTTP modules to startup the server.
use HTTP::Daemon;
use HTTP::Status;

# Load the port they want to use.
use LWP::Simple;
open (PORT, "config/server.txt");
my $port = <PORT>;
close (PORT);

# Load all commands and other necessary files.
print ":: Loading all Perl files...\n";
my @file_folders = (
	"commands",
	"handlers/http",
	"subroutines",
);
foreach $folder (@file_folders) {
	opendir (PL, "./$folder");
	foreach $file (sort(grep(!/^\./, readdir(PL)))) {
		print "\tLoading $folder/$file... ";
		require "./$folder/$file";
		print "Done!\n";
	}
	closedir (PL);
}
print ":: Done loading files.\n";

$d = new HTTP::Daemon (
	LocalPort => $port,
);
print "CKS // Your bot is running at <URL:", $d->url, "> \n\n";
while ($c = $d->accept) {
	$r = $c->get_request;
	if ($r) {
		if ($r->method eq "GET") {
			$wanted = $r->url->path;

			if ($wanted eq "/") {
				$c->send_file_response ("server/home.html");
			}
			elsif ($wanted =~ /chat.html/i) {
				$query = $r->url->query;

				# Go through the query string.
				my @pairs = split(/\&/, $query);
				foreach $pair (@pairs) {
					my ($what,@is) = split(/=/, $pair);
					my $is = join(/=/, @is);

					$what = lc($what);

					# Change pluses to spaces.
					$is =~ s/\+/ /g;

					# Escape URI codes.
					$is =~ s/\%09/\t/g;
					$is =~ s/\%20/ /g;
					$is =~ s/\%21/\!/g;
					$is =~ s/\%22/\"/g;
					$is =~ s/\%23/\#/g;
					$is =~ s/\%24/\$/g;
					$is =~ s/\%25/\%/g;
					$is =~ s/\%26/\&/g;
					$is =~ s/\%27/\'/g;
					$is =~ s/\%28/\(/g;
					$is =~ s/\%29/\)/g;
					$is =~ s/\%2A/\*/g;
					$is =~ s/\%2B/\+/g;
					$is =~ s/\%2C/\,/g;
					$is =~ s/\%2D/\-/g;
					$is =~ s/\%2E/\./g;
					$is =~ s/\%2F/\//g;
					$is =~ s/\%3F/\?/g;
					$is =~ s/\%40/\@/g;

					# Cut off all other characters.
					$is =~ s/\%//g;

					if ($what eq "name" || $what eq "nick") {
						$user_name = $is;
					}
					elsif ($what eq "msg") {
						$user_msg = $is;
					}
				}

				# Call the HTTP IM handler.
				$reply = http_im_in ($user_name,$user_msg);

				# Open the HTML-Chat file.
				open (HTML, "server/chat.html");
				my @source = <HTML>;
				close (HTML);

				$final_html = "";
				foreach $line (@source) {
					chomp $line;
					$line =~ s/\$nick/$user_name/ig;
					$line =~ s/\$msg/$user_msg/ig;
					$line =~ s/\$reply/$reply/ig;
					$final_html .= "$line\n";
				}

				# Save the new source.
				open (NEW, ">server/html-chat.tmp");
				print NEW $final_html;
				close (NEW);

				# Send the file response.
				$c->send_file_response ("server/html-chat.tmp");
			}
			elsif ($wanted =~ /flash.chat/i) {
				print "Query String: ", $r->url->query, "\n\n";
				$query = $r->url->query;

				# Go through the query string.
				my @pairs = split(/\&/, $query);
				foreach $pair (@pairs) {
					my ($what,@is) = split(/=/, $pair);
					my $is = join(/=/, @is);

					$what = lc($what);

					# Change pluses to spaces.
					$is =~ s/\+/ /g;

					# Escape URI codes.
					$is =~ s/\%09/\t/g;
					$is =~ s/\%20/ /g;
					$is =~ s/\%21/\!/g;
					$is =~ s/\%22/\"/g;
					$is =~ s/\%23/\#/g;
					$is =~ s/\%24/\$/g;
					$is =~ s/\%25/\%/g;
					$is =~ s/\%26/\&/g;
					$is =~ s/\%27/\'/g;
					$is =~ s/\%28/\(/g;
					$is =~ s/\%29/\)/g;
					$is =~ s/\%2A/\*/g;
					$is =~ s/\%2B/\+/g;
					$is =~ s/\%2C/\,/g;
					$is =~ s/\%2D/\-/g;
					$is =~ s/\%2E/\./g;
					$is =~ s/\%2F/\//g;
					$is =~ s/\%3F/\?/g;
					$is =~ s/\%40/\@/g;

					# Cut off all other characters.
					$is =~ s/\%//g;

					if ($what eq "name" || $what eq "nick") {
						$user_name = $is;
					}
					elsif ($what eq "msg") {
						$user_msg = $is;
					}
				}

				# Call the HTTP IM handler.
				$reply = http_im_in ($user_name,$user_msg);

				# Save the response file that Flash wants to see.
				open (REPLY, ">server/flash-chat.tmp");
				print REPLY "&accept=1&reply=$reply";
				close (REPLY);

				# Send the file response.
				$c->send_file_response ("server/flash-chat.tmp");
			}
			else {
				$c->send_file_response ("server/$wanted");
			}
		}
		else {
			$c->send_file_response ("server/404.html");
		}
	}
	$c = undef; # Close connection
}