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
# MSN Handler: close
# Description: Called when a socket is terminated.

sub msn_close {
	# Get variables from the server.
	my $notify = shift;

	# Get this socket.
	my $sock = $notify->getID;

	# Our handle.
	my $sn = $notify->{Msn}->{Handle};
	$sn = lc($sn); $sn =~ s/ //g;

	########################################
	# See if this socket existed anywhere. #
	########################################

	print "ChaosMSN: Now closing socket #$sock.\n";

	# A "Shut Up!" socket.
	if (exists $chaos->{$sn}->{_shutup}->{$sock}) {
		delete $chaos->{$sn}->{_shutup}->{$sock};
		print "\t$sock was a \"shut up\" sock - now deleted!\n";
	}

	# Azulian Tag socket.
	foreach my $atag (keys %{$chaos->{_data}->{atag}->{players}}) {
		# 1) See if this is an MSN player.
		# 2) See if we're their host.
		# 3) See if this is the same socket.
		if (exists $chaos->{_data}->{atag}->{players}->{$atag}->{sock} &&
		    $chaos->{_data}->{atag}->{players}->{$atag}->{host} eq "$sn" &&
		    $chaos->{_data}->{atag}->{players}->{$atag}->{sock} eq "$sock") {
			# Delete this player.
			delete $chaos->{_data}->{atag}->{players}->{$atag};
			delete $chaos->{_users}->{$atag}->{callback};

			# Send a message to Azulian Tag players.
			&atag_sendmsg ('idle', $atag);

			print "\t$sock was an Azulian Tag player - now idle'd out of the game!\n";
		}
	}

	# J'naut Chat Socket
	foreach my $chatter (keys %{$chaos->{_data}->{chatsys}->{members}}) {
		# 1) Check if the sock exists.
		# 2) See if they're an MSN user.
		# 3) See if this is their socket.
		# 4) See if we're their host.
		if (exists $chaos->{_data}->{chatsys}->{members}->{$chatter}->{sock} &&
		    $chaos->{_data}->{chatsys}->{members}->{$chatter}->{sock} eq "$sock" &&
		    $chaos->{_data}->{chatsys}->{members}->{$chatter}->{listener} eq "msn" &&
		    $chaos->{_data}->{chatsys}->{members}->{$chatter}->{host} eq "$sn") {
			# Delete this player.
			delete $chaos->{_data}->{chatsys}->{members}->{$chatter};
			delete $chaos->{_users}->{$chatter}->{callback};

			# Send a chat message.
			&chat_send ('idle', $chatter);

			print "\t$sock was a Chat Member - now idle'd out of the room!\n";
		}
	}

	return 1;
}
1;