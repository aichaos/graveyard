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
# AIM Handler: aim_im_in
# Description: Handles incoming messages.

sub aim_im_in {
	# Get variables from the server.
	my ($aim,$client,$msg,$away) = @_;

	# Get comment tags off.
	$msg =~ s/<\!\-\-//ig;
	$msg =~ s/\-\->//ig;

	my $screenname = $aim->screenname();
	my $time = localtime();

	my $sn = lc($screenname);
	$sn =~ s/ //g;

	# Make sure this wasn't an "away message"
	if ($away == 0) {
		# Format the screenname (lowercase, remove spaces).
		$client = lc($client);
		$client =~ s/ //g;

		# Not in chat.
		$chaos->{$screenname}->{current_user}->{in_chat} = 0;

		# Filter the message for HTML.
		$msg =~ s/<(.|\n)+?>//g;

		# Save an original unformatted copy of the message.
		my $omsg = $msg;

		# Send this data to our message handler.
		my $reply = on_im ($aim,$screenname,$client,$msg,$omsg,"AIM");

		my @out = split(/\<\:\>/, $reply);

		# See if they're muted.
		if ($chaos->{_users}->{$client}->{mute} == 0) {
			# Send if these conditions aren't met.
			if ($reply ne "<notcommand>" && $reply !~ /<noreply/i && $reply ne "<blocked>") {
				foreach my $send (@out) {
					if ($send !~ /<font/i) {
						my $font = get_font ($screenname, "AIM");
						$send = $font . $send;
					}

					# Send typing status?
					if ($chaos->{$sn}->{_oscar} eq '1.11') {
						# Queue this up.
						&queue (0,"\$chaos->{$sn}->{client}->send_typing_status (\"$client\",TYPINGSTATUS_STARTED);");
					}

					# Avoid syntax.
					$send =~ s/\'/\\'/g;

					# If this is to be an auto-response...
					if ($send =~ /<auto>/i) {
						$send =~ s/<auto>//ig;

						# Queue this up.
						&queue (3,"\$chaos->{$sn}->{client}->send_im (\"$client\",\'$send\',1);");
					}
					else {
						# Queue this up.
						&queue (3,"\$chaos->{$sn}->{client}->send_im (\"$client\",\'$send\');");
					}

					# Send typing status?
					if ($chaos->{$sn}->{_oscar} eq '1.11') {
						# Queue this up.
						&queue (0,"\$chaos->{$sn}->{client}->send_typing_status (\"$client\",TYPINGSTATUS_FINISHED);");
					}
				}
			}
		}
	}
}
1;