#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !html
#    .::   ::.     Description // Test some HTML codes.
# ..:;;. ' .;;:..        Usage // !html <codes>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub html {
	my ($self,$client,$msg,$listener) = @_;

	# If there's some code...
	if (length $msg > 0) {
		# Convert codes.
		$msg =~ s/\&lt\;/</ig;
		$msg =~ s/\&gt\;/>/ig;
		$msg =~ s/\&amp\;/\&/ig;
		$msg =~ s/\&quot\;/"/ig;
		$msg =~ s/\&apos\;/'/ig;

		# See if the server is running.
		open (SERVER, "./config/server.cfg");
		my @data = <SERVER>;
		close (SERVER);
		chomp @data;

		my $server_host = 'localhost';
		my $server_port = '2001';

		foreach my $line (@data) {
			my ($what,$is) = split(/=/, $line, 2);
			$what = lc($what);
			$what =~ s/ //g;

			$server_host = $is if $what eq 'serverhost';
			$server_port = $is if $what eq 'serverport';
		}

		my $server = "http://" . $server_host . ":" . $server_port;

		# See if we can ping the server.
		my $ping = LWP::Simple::get "$server/ping.txt";
		if ($ping == 1) {
			# Save the file.
			open (FILE, ">./server/temp/$listener\-$client\.html");
			print FILE $msg;
			close (FILE);

			return "Your file has been saved to the URL below. Click to see it:\n\n"
				. "$server/temp/$listener\-$client\.html";
		}
		else {
			return "The Juggernaut HTTP server is inactive and I cannot complete "
				. "the request.";
		}
	}
	else {
		return "Give me some HTML codes to evaluate.";
	}
}

{
	Category => 'General Utilities',
	Description => 'HTML Evaluator',
	Usage => '!html <codes>',
	Listener => 'All',
};