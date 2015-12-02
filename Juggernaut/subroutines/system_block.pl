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
#  Subroutine: system_block
# Description: Blocks a user.

sub system_block {
	# Get variables from the shift.
	my ($client,$listener,$time,$save) = @_;

	if (length $client == 0 || length $listener == 0) {
		&panic ("Unrecieved client or listener at system_block.pl", 0);
		return 1;
	}

	if ($save eq "") {
		$save = 0;
	}

	my $block_time;

	# Lower their stars count.
	&profile_get ($client,$listener);
	my $stars = $chaos->{_users}->{$client}->{stars};
	if ($save == 0) {
		$stars--;
		&profile_send ($client,$listener,"stars",$stars);
	}

	# If they've reached their limit (-5 stars).
	if ($stars <= -5) {
		# Put them on the blacklist.
		open (BLACK, ">>./data/blacklist.txt");
		print BLACK "$client\n";
		close (BLACK);
		print "CKS // $client has been banned permanently.\n\n";
		return 1;
	}

	# If they are to be banned.
	if ($time == 0) {
		$block_time = "ban";
	}
	else {
		$block_time = (time + 60 * 60 * $time);
	}

	# If this isn't a safe block, block them.
	if ($save == 0) {
		print "CKS // Blocking $client for $time (hours).\n\n";

		# Save this block.
		my $person = ($listener . "-" . $client);
		$chaos->{_data}->{blocks}->{$person} = "$block_time";
		open (BLOCK, ">./data/blocks/$person.txt");
		print BLOCK $block_time;
		close (BLOCK);
	}
	else {
		print "CKS // Safe Block Called for $client.\n\n";
	}

	# Return true.
	return 1;
}
1;