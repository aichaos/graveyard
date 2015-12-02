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
# IRC Handler: irc_connect
# Description: Handles connection.

sub irc_connect {
	# Get variables from the server.
	my $self = shift;

	# Get localtime and our nickname.
	my $time = localtime();
	my $sn = $self->nick;
	$sn = lc($sn);
	$sn =~ s/ //g;

	print "IRC_Connect: My Nickname: $sn\n\n";

	# Get what channel we were going to.
	my $chan = $chaos->{$sn}->{channel} || '#lobby';

	print "<$time>\n"
		. "ChaosIRC: " . $self->nick . " connected successfully!\n"
		. "ChaosIRC: Joining channel $chan...\n";
	$self->join ($chan);
	$self->topic ($chan);

	print "ChaosIRC: Join success!\n\n";
}
1;