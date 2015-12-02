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
# MSN Handler: join
# Description: Called when somebody joins the conversation.

sub msn_join {
	my ($self,$client,$name) = @_;

	# Get local data.
	my $stamp = &get_timestamp();
	my $sn = $self->{Msn}->{Handle};
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Socket.
	my $sock = $self->getID;

	# Save this for later.
	$chaos->{bots}->{$sn}->{sock_members}->{$sock} .= ",$client";

	print "$stamp\n"
		. "ChaosMSN: $client has joined the conversation (#$sock)\n"
		. "\tBot: $sn\n\n";

	# Get our font.
	my ($font,$color,$style) = &get_font ($sn,'MSN');

	# If not allowed to chat...
	if ($chaos->{config}->{msn}->{allow_chat} == 0) {
		# We may have called him though.
		my $mem = $self->getMembers();
		my @members = keys %{$mem};
		if (scalar(@members) > 1) {
			&queue ($sn, 0, "my \$convo = \$chaos->{bots}->{'$sn'}->{client}->getConvo ($sock); "
				. "\$convo->leave();");
			print "$stamp\n"
				. "Leaving socket #$sock -- too many members.\n"
				. "\tBot: $sn\n\n";
			delete $chaos->{bots}->{$sn}->{sock_members}->{$sock};
			return 1;
		}
	}
	else {
		# Greet them.
		print "$stamp\n"
			. "ChaosMSN: [$sn] Hey, $name!\n\n";
		$self->sendMessage ("Hey, $name!",
			Font   => $font,
			Color  => $color,
			Effect => $style,
		);
	}
}
{
	Type        => 'handler',
	Name        => 'msn_join',
	Description => 'Called when somebody joins the conversation.',
	Author      => 'Cerone Kirsle',
	Created     => '1:16 PM 11/21/2004',
	Updated     => '11:23 AM 1/22/2005',
	Version     => '1.1',
};