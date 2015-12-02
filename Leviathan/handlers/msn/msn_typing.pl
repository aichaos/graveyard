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
# MSN Handler: typing
# Description: Called when a user begins typing.

sub msn_typing {
	my ($self,$client,$name) = @_;

	# Get timestamp and format the client's name.
	$client = 'MSN-' . $client;
	my $stamp = &get_timestamp();
	my $sn = $self->{Msn}->{Handle};
	$sn =~ s/ //g; $sn = lc($sn);

	# Send the welcome message?
	if (!exists $self->{_leviathan_welcome}) {
		$self->{_leviathan_welcome} = 1;

		# Get the bot's font.
		my ($font,$color,$style) = &get_font ($sn,'MSN');

		# Load the welcome message.
		if (-e "$chaos->{bots}->{$sn}->{welcomemsg}") {
			open (MSG, $chaos->{bots}->{$sn}->{welcomemsg});
			my @msg = <MSG>;
			close (MSG);
			chomp @msg;

			# Send the message.
			$self->sendMessage (join("\n",@msg),
				Font   => $font,
				Color  => $color,
				Effect => $style,
			);

			print "$stamp\n"
				. "ChaosMSN: [$sn] " . join("\n",@msg) . "\n\n";
		}
	}
}
{
	Type        => 'handler',
	Name        => 'msn_typing',
	Description => 'Called when a user begins typing.',
	Author      => 'Cerone Kirsle',
	Created     => '1:21 PM 4/3/2005',
	Updated     => '1:25 PM 4/3/2005',
	Version     => '1.0',
};