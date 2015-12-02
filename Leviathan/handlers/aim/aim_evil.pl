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
# AIM Handler: evil
# Description: Handles warnings.

sub aim_evil {
	my ($aim,$level,$from) = @_;

	# Get some data.
	my $screenname = $aim->screenname();
	my $time = &get_timestamp();

	print "$time\n"
		. "ChaosAIM: $screenname has been warned to $level\%! ";

	# See if this was anonymous.
	if (not defined $from) {
		print "The coward did this anonymously!\n\n";
	}
	else {
		print "$from did this!\n"
			. "ChaosAIM: I'm getting revenge on $from!\n\n";

		# Warn and block this idiot.
		$aim->evil ($from,0);
		$aim->evil ($from,0);
		$aim->evil ($from,0);
		$aim->add_deny ($from);

		# Format the user.
		my $client = lc($from);
		$client =~ s/ //g;
		$client = 'AIM-' . $client;

		# If the warners list doesn't exist, create it.
		if (-e "./data/warners.txt") {
			open (ADD, ">>./data/warners.txt");
			print ADD "\n$client";
			close (ADD);
		}
		else {
			open (NEW, ">./data/warners.txt");
			print NEW $client;
			close (NEW);
		}
	}
}
{
	Type        => 'handler',
	Name        => 'aim_evil',
	Description => 'Handles warnings.',
	Author      => 'Cerone Kirsle',
	Created     => '2:57 PM 11/20/2004',
	Updated     => '2:57 PM 11/20/2004',
	Version     => '1.0',
};