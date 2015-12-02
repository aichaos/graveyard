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
# TOC Handler: evil
# Description: Handles warnings.

sub toc_evil {
	my ($aim,$evt,$from,$to) = @_;
	my ($level,$culprit) = @{$evt->args};

	# Get localtime and username.
	my $stamp = &get_timestamp();
	my $sn = $aim->{botscreenname};
	$sn = lc($sn);
	$sn =~ s/ //g;

	print "$stamp\n"
		. "ChaosTOC: $sn has been warned to $level\%! ";

	# Get revenge.
	if ($culprit =~ /^\s*$/) {
		my $client = $aim->normalize($culprit);

		print "$client did this!\n"
			. "ChaosTOC: Getting revenge on $client...\n\n";

		# Warn them three times in revenge.
		$aim->evil($client);
		$aim->evil($client);
		$aim->evil($client);

		# Add them to the warners list.
		$client = lc($client); $client =~ s/ //g;
		if (-e "./data/warners.txt") {
			open (WARNERS, ">>./data/warners.txt");
			print WARNERS "\nTOC-" . $client;
			close (WARNERS);
		}
		else {
			open (WARNERS, ">./data/warners.txt");
			print WARNERS "TOC-" . $client;
			close (WARNERS);
		}
	}
	else {
		print "The bastard did this anonymously!\n\n";
	}
}
{
	Type        => 'handler',
	Name        => 'toc_evil',
	Description => 'Handles warnings.',
	Author      => 'Cerone Kirsle',
	Created     => '12:50 PM 2/6/2005',
	Updated     => '12:50 PM 2/6/2005',
	Version     => '1.0',
};