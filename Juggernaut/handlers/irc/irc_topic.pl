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
# IRC Handler: irc_topic
# Description: Handles topic changes.

sub irc_topic {
	# Get variables from the server.
	my ($self,$event) = @_;
	my @args = $event->args();

	my $time = localtime();

	if ($event->type() eq 'notopic') {
		print "<$time>\n"
			. "ChaosIRC: No topic set for $args[1].\n\n";
	}
	elsif ($event->type() eq 'topic' && $event->to()) {
		print "<$time>\n"
			. "ChaosIRC: Topic change for " . $event->to() . ": $args[0]\n\n";
	}
	else {
		print "<$time>\n"
			. "The topic for $args[1] is \"$args[2]\".\n\n";
	}
}
1;