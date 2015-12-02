# HTTP Handler: im_in
# Handles incoming messages.

sub http_im_in {
	# Get messages from the server.
	my ($client,$msg) = @_;

	# Set the HTTP client's name.
	my $nick = "HTTP-$client";

	# No special logim's.
	my $log_im = "plain";

	# Format the client's name.
	$client = lc($client);
	$client =~ s/ //g;

	# Format the message.
	$msg =~ s/<(.|\n)+?>//g;
	$msg = lc($msg);

	# Save an original copy of the message.
	my $omsg = $msg;

	# Make sure they're not blocked.
	my $blocked = blocked($nick);

	# If they're not blocked, continue.
	if ($blocked == 0) {
		# See if this is a command.
		my ($is_a_command,$reply) = commands($nick,$msg);

		# If it's not a command, continue.
		if ($is_a_command == 0) {
			# Filter the message for puncuation.
			$msg = filter($msg);

			# Get a reply.
			$reply = respond ($nick,$msg,$omsg);
		}

		# Log this IM.
		&log_im ($nick,$omsg,"Server",$reply,$log_im,"ChaosHTTP");

		# Send the reply back... if there is one.
		if ($reply ne "noreply" && $reply ne "notcommand") {
			# Filter \n to <br>
			$reply =~ s/\n/<br>/ig;
			return $reply;
		}
		else {
			return "";
		}
	}
}
1;