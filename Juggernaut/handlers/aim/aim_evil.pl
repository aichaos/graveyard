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
# AIM Handler: aim_evil
# Description: Handles warnings (warners need to die :P)

sub aim_evil {
	# Get variables from the server.
	my ($aim,$level,$from) = @_;

	my $screenname = $aim->screenname();
	my $time = localtime();

	# Print this invitation.
	print "ChaosAIM: $screenname has been warned to $level\%! ";

	# Get our last person who IM'd us.
	$screenname = lc($screenname);
	$screenname =~ s/ //g;
	my $last = $chaos->{$screenname}->{last_client};

	# See if this user was anonymous.
	if (not defined $from) {
		print "The coward did this anonymously!\n"
			. "ChaosAIM: Assuming $last did this! Blocking $last for 24 hours.\n\n";
		&system_block ($last,"AIM", "24");
	}
	else {
		print "$from did this! That bastard!\n"
			. "ChaosAIM: I'm getting revenge on $from!\n\n";

		# Warn and block this idiot.
		$aim->evil ($from, 0);
		$aim->evil ($from, 0);
		$aim->evil ($from, 0);
		$aim->add_deny ($from);

		# If the warners list doesn't exist, create it.
		if (-e "./data/warners.txt" == 0) {
			open (LIST, ">./data/warners.txt");
			print LIST "$from";
			close (LIST);
		}
		else {
			# If it exists, append on to it.
			open (LIST, ">>./data/warners.txt");
			print LIST "\n$from";
			close (LIST);
		}
	}
}
1;