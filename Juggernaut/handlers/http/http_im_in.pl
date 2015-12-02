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
# HTTP Handler: im_in
#  Description: Handles incoming messages.

sub http_im_in {
	# Get variables from the server.
	my ($client,$msg) = @_;

	# Get the local time and our handle.
	my $time = localtime();
	my $screenname = '_http';

	# Format the client's e-mail address.
	$client = lc($client);
	$client =~ s/ //g;

	# Format the message for HTML.
	$msg =~ s/<(.|\n)+?>//g;

	# Save an unformatted copy of the message.
	my $omsg = $msg;

	# Send this to the message handler.
	my $void = "Juggernaut HTTP Server 1.0";
	my $reply = on_im ($void,$screenname,$client,$msg,$omsg,"HTTP");

	$reply =~ s/\<\:\>/<br><br>/ig;

	# Send the reply if these conditions aren't met.
	if ($reply ne "<notcommand>" && $reply !~ /\<noreply/i && $reply ne "<blocked>") {
		# See if we're muted.
		if ($chaos->{_users}->{$client}->{mute} == 0) {
			$reply =~ s/size=\"2\"/size=\"10\"/ig;
			$reply =~ s/\n/<br>/ig;
			my $font = "<font face=\"Verdana,Arial\" size=\"10\" color=\"\#FFFFFF\">";
			return ($font . $reply);
		}
	}
}
1;