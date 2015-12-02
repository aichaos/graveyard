# Subroutine: log_im
# Logs Instant Messages recieved by the bot.

sub log_im {
	# Get all the variables needed from the shift.
	my ($client,$msg,$screenname,$reply,$log_im,$chaos_listener) = @_;

	# Filter HTML out of $reply.
	$reply =~ s/<(.|\n)+?>//g;

	# The local time.
	my $time = localtime();

	# Save this conversation in the user's personal folder.
	open (PERSONAL, ">>./logs/clients/$client.txt");
	print PERSONAL ("$time\n"
		. "[$client] $msg\n"
		. "[$screenname] $reply\n\n");
	close (PERSONAL);

	# If this IM is not being hidden...
	if ($log_im ne "hidden") {
		# Save this conversation in the collective log files.
		if (-e "./logs/$screenname.html" == 1) {
			open (LOG, ">>./logs/$screenname.html");
			print LOG ("<b>$time</b><br>\n"
				. "<font color=\"\#0000FF\"><b>$client:</b></font> $msg<br>\n"
				. "<font color=\"\#FF0000\"><b>$screenname:</b></font> $reply<p>\n\n");
			close (LOG);
		}
		else {
			open (LOG, ">./logs/$screenname.html");
			print LOG ("<html>\n"
				. "<head>\n"
				. "<title>Conversation Logs for $screenname</title>\n"
				. "</head>\n"
				. "<body bgcolor=\"white\" link=\"blue\" vlink=\"blue\" "
				. "alink=\"red\" text=\"black\">\n"
				. "<b>$time</b><br>\n"
				. "<font color=\"\#0000FF\"><b>$client:</b></font> $msg<br>\n"
				. "<font color=\"\#FF0000\"><b>$screenname:</b></font> $reply<p>\n\n");
			close (LOG);
		}

		# Print the logs to the DOS window.
		print "$time\n";
		print "$chaos_listener: [$client] $msg\n";
		print "$chaos_listener: [$screenname] $reply\n\n";
	}
	else {
		# Do not show or save IM logs.
	}
}
1;