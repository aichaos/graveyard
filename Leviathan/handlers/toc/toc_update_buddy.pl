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
# TOC Handler: update_buddy
# Description: Handles buddy updates.

sub toc_update_buddy {
	my ($aim,$evt,$from,$to) = @_;
	my $client = $from;
	my ($bud,$online,$evil,$signon_time,$idle_amount,$user_class) = @{$evt->args};

	# Get localtime and username.
	my $stamp = &get_timestamp();
	my $sn = $aim->{botscreenname};
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Print this.
	print "$stamp\n";
	if ($online eq 'T') {
		print "ChaosTOC: $bud has signed on.\n\n";
	}
	elsif ($online eq 'F') {
		print "ChaosTOC: $bud has signed off.\n\n";
	}
}
{
	Type        => 'handler',
	Name        => 'toc_update_buddy',
	Description => 'Handles buddy updates.',
	Author      => 'Cerone Kirsle',
	Created     => '1:00 PM 2/6/2005',
	Updated     => '1:00 PM 2/6/2005',
	Version     => '1.0',
};