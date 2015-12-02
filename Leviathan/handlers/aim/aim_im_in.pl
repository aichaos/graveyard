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
# AIM Handler: im_in
# Description: Handles instant messages.

sub aim_im_in {
	my ($aim,$client,$msg,$away) = @_;

	# Get some data.
	my $screenname = $aim->screenname();
	my $time = &get_timestamp();

	my $sn = lc($screenname);
	$sn =~ s/ //g;

	# If an away message...
	if ($away == 1) {
		print "$time\n"
			. "ChaosAIM: Automessage from $client: $msg\n\n";
	}
	else {
		# Format the username.
		$client = lc($client);
		$client =~ s/ //g;
		my $username = $client;
		$client = 'AIM-' . $client;

		# Filter out HTML.
		$msg =~ s/<(.|\n)+?>//g;

		# Save an original copy of the message.
		my $omsg = $msg;

		# Send this data to the brain.
		my $reply = &on_im ($aim,$sn,$client,$msg,$omsg);

		my @out = split(/<:>/, $reply);

		# If not muted...
		if ($chaos->{clients}->{$client}->{mute} != 1) {
			# Send if these conditions aren't met.
			if ($reply ne '<notcommand>' && $reply !~ /<noreply/i && $reply ne '<blocked>') {
				foreach my $send (@out) {
					my ($font,$smile) = &get_font ($sn,'AIM');
					if ($send !~ /<font/i) {
						$font =~ s/$smile//g;
						$send = CORE::join ("", $font, $send);
					}

					# Filter in smileys.
					if (length $smile > 0) {
						$send =~ s~o:\-\)~<font sml=\"$smile\">o:\-\)<\/font>~ig; # o:-)
						$send =~ s~:\-\)~<font sml=\"$smile\">:\-\)<\/font>~ig;   # :-)
						$send =~ s~:\)~<font sml=\"$smile\">:\)<\/font>~ig;       # :)
						$send =~ s~:\-d~<font sml=\"$smile\">:\-D<\/font>~ig;     # :-D
						$send =~ s~:\-p~<font sml=\"$smile\">:\-p<\/font>~ig;     # :-P
						$send =~ s~:\-\\~<font sml=\"$smile\">:\-\\<\/font>~ig;   # :-\
						$send =~ s~:\-\/~<font sml=\"$smile\">:\-\/<\/font>~ig;   # :-/
						$send =~ s~:\-\!~<font sml=\"$smile\">:\-\!<\/font>~ig;   # :-!
						$send =~ s~:\-\$~<font sml=\"$smile\">:\-\$<\/font>~ig;   # :-$
						$send =~ s~:\-\[~<font sml=\"$smile\">:\-\[<\/font>~ig;   # :-[
						$send =~ s~=\-o~<font sml=\"$smile\">=\-o<\/font>~ig;     # =-o
						$send =~ s~\;\-\)~<font sml=\"$smile\">\;\-\)<\/font>~ig; # ;-)
						$send =~ s~\;\)~<font sml=\"$smile\">\;\)<\/font>~ig;     # ;)
						$send =~ s~:\'\(~<font sml=\"$smile\">:\'\(<\/font>~ig;   # :'(
						$send =~ s~:\(~<font sml=\"$smile\">:\-\(<\/font>~ig;     # :(
						$send =~ s~:\-\(~<font sml=\"$smile\">:\-\(<\/font>~ig;   # :(
						$send =~ s~8\-\)~<font sml=\"$smile\">8\-\)<\/font>~ig;   # 8-(
						$send =~ s~>:o~<font sml=\"$smile\">&gt;:o<\/font>~ig;    # >:o
					}

					# Send typing status.
					&queue ($sn,0,"\$chaos->{bots}->{$sn}->{client}->send_typing_status ('$username',TYPINGSTATUS_STARTED);");

					# Avoid syntax.
					$send =~ s/\'/\\'/g;

					# If this is an auto-response...
					if ($send =~ /<auto>/i) {
						$send =~ s/<auto>//ig;

						# Queue this up.
						&queue ($sn,3,"\$chaos->{bots}->{$sn}->{client}->send_im ("
							. "'$username','$send',1);");
					}
					else {
						# Queue this up.
						&queue ($sn,3,"\$chaos->{bots}->{$sn}->{client}->send_im ("
							. "'$username','$send');");
					}

					# Send typing status.
					&queue ($sn,0,"\$chaos->{bots}->{$sn}->{client}->send_typing_status ("
						. "'$username',TYPINGSTATUS_FINISHED);");
				}
			}
		}
	}
}
{
	Type        => 'handler',
	Name        => 'aim_im_in',
	Description => 'Handles Instant Messages.',
	Author      => 'Cerone Kirsle',
	Created     => '3:05 PM 11/20/2004',
	Updated     => '3:05 PM 11/20/2004',
	Version     => '1.0',
};