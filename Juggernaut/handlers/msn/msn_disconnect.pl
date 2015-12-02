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
# MSN Handler: disconnect
# Description: Called when the connection has been lost.

$chaos->{_data}->{temp}->{msncount} = 0;

sub msn_disconnect {
	# Get variables from the server.
	my $self = shift;
	my $reason = shift || 'unknown';

	$chaos->{_data}->{temp}->{msncount}++;
	if ($chaos->{_data}->{temp}->{msncount} >= 6) {
		# CKS Server only.
		if (-e "./chaos.id") {
			system ("ipconfig /release");
			sleep (5);
			system ("ipconfig /renew");
			sleep (10);
			system ("start Juggernaut.bat");
			die "Restarting";
		}
	}

	# Get the local time and our handle.
	my $time = localtime();
	my $screenname = $self->{Handle};
	$screenname = lc($screenname);
	$screenname =~ s/ //g;

	# Print this.
	print "ChaosMSN: $screenname has been disconnected (Reason: $reason)\n"
		. "ChaosMSN: $screenname reconnect scheduled in 5 minutes.\n\n";
	&dosleep (60*5);
	print "\aChaosMSN: $screenname reconnecting to MSN.\n\n";

	$self->connect ();
}
1;