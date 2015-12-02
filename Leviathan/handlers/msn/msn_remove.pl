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
# MSN Handler: remove
# Description: Called when somebody removes us.

sub msn_remove {
	my ($self,$client) = @_;

	my $stamp = &get_timestamp();
	my $sn = $self->{Msn}->{Handle};
	$sn = lc($sn);
	$sn =~ s/ //g;

	print "$stamp\n"
		. "ChaosMSN: $client has removed $sn from their contact list.\n\n";
}
{
	Type        => 'handler',
	Name        => 'msn_remove',
	Description => 'Called when somebody removes us.',
	Author      => 'Cerone Kirsle',
	Created     => '1:18 PM 11/21/2004',
	Updated     => '1:18 PM 11/21/2004',
	Version     => '1.0',
};