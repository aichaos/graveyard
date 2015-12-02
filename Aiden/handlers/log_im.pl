# Logs IM's.

sub log_im {
	my ($client,$msg,$bot,$reply) = @_;

	# Get client data.
	my ($listener,$name) = split(/\-/, $client, 2);

	my $tag = join ('', 'Aiden', $listener);

	# Make directories.
	mkdir ("./logs") unless -d "./logs";
	mkdir ("./logs/chat") unless -d "./logs/chat";
	mkdir ("./logs/chat/$tag") unless -d "./logs/$tag";

	# Files to update.
	my @update = (
		"./logs/chat/convo.html",
		"./logs/chat/$tag/$client\.html",
	);

	my $time = &timestamp();

	foreach my $file (@update) {
		if (!-e $file) {
			open (BEGIN, ">$file");
			print BEGIN "<html>\n"
				. "<head>\n"
				. "<title>Aiden Conversation Log</title>\n"
				. "<style type=\"text/css\">\n"
				. ".timestamp { color: #FF00FF }\n"
				. ".in { color: #0000FF }\n"
				. ".out { color: #FF0000 }\n"
				. "</style>\n"
				. "</head>\n"
				. "<body bgcolor=\"#FFFFFF\" link=\"#0000FF\" vlink=\"#0000FF\" "
				. "alink=\"#FF0000\" text=\"#000000\" style=\"font-family: Verdana; "
				. "font-size: 10pt; color: #000000\">\n";
			close (BEGIN);
		}

		open (ADD, ">>$file");
		print ADD "<b class=\"timestamp\">$time</b><br>\n"
			. "<b>$tag</b> <b class=\"in\">$client:</b> $msg<br>\n"
			. "<b>$tag</b> <b class=\"out\">$bot:</b> $reply<br><br>\n\n";
		close (ADD);
	}

	# Finally, print to DOS.
	print "$time\n"
		. "$tag: [$client] $msg\n"
		. "$tag: [$bot] $reply\n\n";
}
1;