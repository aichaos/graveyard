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
# IRC Handler: irc_names
# Description: Handles the list of IRC users in chat.

sub irc_names {
	# Get variables from the server.
	my ($self,$event) = @_;
	my (@list,$channel) = ($event->args);

	# Get localtime and our nickname.
	my $time = localtime();
	my $sn = $self->nick;
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Splice them.
	($channel,@list) = splice (@list, 2);

	print "<$time>\n"
		. "ChaosIRC: Users on channel: " . join (", ", @list) . "\n\n";
}
1;