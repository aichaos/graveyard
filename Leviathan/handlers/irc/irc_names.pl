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
# IRC Handler: names
# Description: Called for each user in the channel.

sub irc_names {
	# Get data from the server.
	my ($self,$event) = @_;
	my (@list,$channel) = ($event->args);

	my $stamp = &get_timestamp();
	my $sn = $self->nick;
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Mark them online.
	print "$stamp\n";
	foreach my $user (@list) {
		$chaos->{data}->{irc}->{$channel}->{$user} = 1;

		print "ChaosIRC: $user is in channel $channel.\n";
	}

	print "\n";
}
{
	Type        => 'handler',
	Name        => 'irc_names',
	Description => 'Called for each user in the channel.',
	Author      => 'Cerone Kirsle',
	Created     => '2:15 PM 12/19/2004',
	Updated     => '2:15 PM 12/19/2004',
	Version     => '1.0',
};