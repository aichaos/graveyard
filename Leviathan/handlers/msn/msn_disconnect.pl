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
# Description: Handles disconnections.

sub msn_disconnect {
	my $msn = shift;
	my $reason = shift || 'unknown';

	# Get local data.
	my $stamp = &get_timestamp();
	my $sn = $msn->{Handle};
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Print this.
	print "$stamp\n"
		. "ChaosMSN: $sn has been disconnected (Reason: $reason)\n\n";
}
{
	Type        => 'handler',
	Name        => 'msn_disconnect',
	Description => 'Handles disconnections.',
	Author      => 'Cerone Kirsle',
	Created     => '1:08 PM 11/21/2004',
	Updated     => '1:08 PM 11/21/2004',
	Version     => '1.0',
};