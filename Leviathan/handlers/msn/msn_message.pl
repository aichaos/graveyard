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
# MSN Handler: message
# Description: Handles Instant Messages.

sub msn_message {
	my ($self,$client,$name,$msg) = @_;

	# Get timestamp and handle.
	my $stamp = &get_timestamp();
	my $sn = $self->{Msn}->{Handle};
	$sn = lc($sn);
	$sn =~ s/ //g;

	my $sock = $self->getID;

	# Format the client.
	$client = lc($client);
	$client =~ s/ //g;
	my $username = $client;
	$client = 'MSN-' . $client;

	# Save their nickname for later use.
	$chaos->{bots}->{$sn}->{current_user}->{nick} = $name;

	# Save unformatted copy.
	my $omsg = $msg;

	# Send this to the reply handler.
	my $reply = &on_im ($self,$sn,$client,$msg,$omsg);
	my @out = split(/<:>/, $reply);

	# Send the reply if these conditions aren't met.
	if ($reply !~ /<notcommand>/i && $reply !~ /<noreply/i && $reply !~ /<blocked>/i) {
		# See if we're muted.
		if ($chaos->{clients}->{$client}->{mute} == 0) {
			# Get the font.
			my ($font,$color,$style) = &get_font ($sn,'MSN');

			# Send each reply.
			foreach my $send (@out) {
				# Filter the reply for HTML. MSN doesn't support them.
				$send =~ s/<(.|\n)+?>//g;
				$send =~ s/\&lt\;/\</ig;
				$send =~ s/\&gt\;/\>/ig;
				$send =~ s/\&amp\;/\&/ig;
				$send =~ s/\&quot\;/\"/ig;
				$send =~ s/\&apos\;/\'/ig;

				$send =~ s/\'/\\'/ig;

				# Queue it up!
				$chaos->{bots}->{$sn}->{keep_objects}->{$sock} = $self;
				&queue ($sn,0,"\$chaos->{bots}->{'$sn'}->{keep_objects}->{$sock}->sendTyping();");
				&queue ($sn,1,"\$chaos->{bots}->{'$sn'}->{keep_objects}->{$sock}->sendMessage ('$send',\n"
					. "Font   => \"$font\",\n"
					. "Color  => \"$color\",\n"
					. "Effect => \"$style\",\n"
					. ");");
			}
		}
	}
}
{
	Type        => 'handler',
	Name        => 'msn_message',
	Description => 'Handles Instant Messages.',
	Author      => 'Cerone Kirsle',
	Created     => '1:31 PM 11/21/2004',
	Updated     => '1:31 PM 11/21/2004',
	Version     => '1.0',
};