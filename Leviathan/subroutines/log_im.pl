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
#  Subroutine: log_im
# Description: Logs Instant Messages.

sub log_im {
	# Get log data.
	my ($client,$msg,$sn,$reply) = @_;

	my ($listener,$nick) = split(/\-/, $client, 2);

	# Return if the user is cloaked.
	return if $chaos->{clients}->{$client}->{cloak} == 1;

	# Get the time stamp.
	my $stamp = &get_timestamp();

	# Get the listener ID.
	$listener = 'Chaos' . $listener;

	# Print to the DOS window.
	print "$stamp\n"
		. "$listener: [$client] $msg\n"
		. "$listener: [$sn] $reply\n\n";

	# Don't log if log type is set to 0.
	return if $chaos->{config}->{logtype} == 0;

	# Make sure all the log folders exist...
	mkdir ("./logs/chat") unless (-d "./logs/chat");
	mkdir ("./logs/chat/$listener") unless (-d "./logs/$listener");

	# Log Type 1: PlainText Logging.
	if ($chaos->{config}->{logtype} == 1) {
		# Collective logs.
		open (TXTALL, ">>./logs/chat/convo.txt");
		print TXTALL "$stamp\n"
			. "$listener: [$client] $msg\n"
			. "$listener: [$sn] $reply\n\n";
		close (TXTALL);

		# Individual logs.
		open (TXTIND, ">>./logs/chat/$listener/$client\.txt");
		print TXTIND "$stamp\n"
			. "$listener: [$client] $msg\n"
			. "$listener: [$sn] $reply\n\n";
		close (TXTIND);
	}
	elsif ($chaos->{config}->{logtype} == 2) {
		# HTML Logs.
		$msg =~ s/\n/<br>/ig;
		$reply =~ s/\n/<br>/ig;

		# Collective logs.
		if (-e "./logs/chat/convo.html") {
			open (HTML, ">>./logs/chat/convo.html");
			print HTML "<b><font color=\"#FF00FF\">&lt;$stamp&gt;</font></b><br>\n"
				. "<b><i>$listener</i></b>: [<b><font color=\"#0000FF\">$client</font></b>] $msg<br>\n"
				. "<b><i>$listener</i></b>: [<b><font color=\"#FF0000\">$sn</font></b>] $reply<p>\n\n";
			close (HTML);
		}
		else {
			open (NEW, ">./logs/chat/convo.html");
			print NEW "<html>\n"
				. "<head>\n"
				. "<title>AiChaos Leviathan :: Chat Logs</title>\n"
				. "<style type=\"text/css\"><!--\n"
				. ".font {\n"
				. " font-family: Verdana,Arial;\n"
				. " font-size: 10pt\n"
				. "}\n"
				. "-->\n"
				. "</style>\n"
				. "</head>\n"
				. "<body bgcolor=\"#FFFFFF\" link=\"#0000FF\" vlink=\"#0000FF\" alink=\"#FF0000\" "
				. "text=\"#000000\">\n"
				. "<font face=\"Verdana\" size=\"2\" color=\"#000000\" class=\"font\">\n\n"
				. "<b><font color=\"#FF00FF\">&lt;$stamp&gt;</font></b><br>\n"
				. "<b><i>$listener</i></b>: [<b><font color=\"#0000FF\">$client</font></b>] $msg<br>\n"
				. "<b><i>$listener</i></b>: [<b><font color=\"#FF0000\">$sn</font></b>] $reply<p>\n\n";
			close (NEW);
		}

		# Individual logs.
		if (-e "./logs/chat/$listener/$client\.html") {
			open (HTML, ">>./logs/chat/$listener/$client\.html");
			print HTML "<b><font color=\"#FF00FF\">&lt;$stamp&gt;</font></b><br>\n"
				. "<b><i>$listener</i></b>: [<b><font color=\"#0000FF\">$client</font></b>] $msg<br>\n"
				. "<b><i>$listener</i></b>: [<b><font color=\"#FF0000\">$sn</font></b>] $reply<p>\n\n";
			close (HTML);
		}
		else {
			open (NEW, ">./logs/chat/$listener/$client\.html");
			print NEW "<html>\n"
				. "<head>\n"
				. "<title>AiChaos Leviathan :: Chat Logs</title>\n"
				. "<style type=\"text/css\"><!--\n"
				. ".font {\n"
				. " font-family: Verdana,Arial;\n"
				. " font-size: 10pt\n"
				. "}\n"
				. "-->\n"
				. "</style>\n"
				. "</head>\n"
				. "<body bgcolor=\"#FFFFFF\" link=\"#0000FF\" vlink=\"#0000FF\" alink=\"#FF0000\" "
				. "text=\"#000000\">\n"
				. "<font face=\"Verdana\" size=\"2\" color=\"#000000\" class=\"font\">\n\n"
				. "<b><font color=\"#FF00FF\">&lt;$stamp&gt;</font></b><br>\n"
				. "<b><i>$listener</i></b>: [<b><font color=\"#0000FF\">$client</font></b>] $msg<br>\n"
				. "<b><i>$listener</i></b>: [<b><font color=\"#FF0000\">$sn</font></b>] $reply<p>\n\n";
			close (NEW);
		}
	}
	else {
		&panic ("Unspecific log type in the settings.cfg file! Must be 0, 1, or 2!",0);
	}

	return 1;
}
{
	Type        => 'subroutine',
	Name        => 'log_im',
	Usage       => '&log_im ($client,$msg,$bot,$reply)',
	Description => 'Logs Instant Messages.',
	Author      => 'Cerone Kirsle',
	Created     => '9:15 AM 11/21/2004',
	Updated     => '9:15 AM 11/21/2004',
	Version     => '1.0',
};