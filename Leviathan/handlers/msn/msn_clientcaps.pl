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
# MSN Handler: clientcaps
# Description: Handles the receiving of ClientCaps.

sub msn_clientcaps {
	my ($self,$client,%caps) = @_;

	# Get the time and our handle.
	my $stamp = &get_timestamp();
	my $sn = $self->{Msn}->{Handle};
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Print this.
	print "$stamp\n"
		. "ChaosMSN: Received ClientCaps from $client\n";
	foreach my $key (keys %caps) {
		print "\t$key: $caps{$key}\n";
	}

	# Check for a bot.
	my $type = $caps{'Client-Type'} || $caps{'Client-Name'};
	$type = lc($type);
	$type =~ s/ //g;

	if ($type =~ /bot/i) {
		# It's a bot!
		print "ChaosMSN: This user is a bot! Ignoring them...\n\n";
		$client = 'MSN-' . $client;
		&modBlacklist ('add',$client,'MSN Bot - Identified by ClientCaps');
	}
}
{
	Type        => 'handler',
	Name        => 'msn_clientcaps',
	Description => 'Handles the sending of ClientCaps.',
	Author      => 'Cerone Kirsle',
	Created     => '3:11 PM 11/23/2004',
	Updated     => '3:11 PM 11/23/2004',
	Version     => '1.0',
};