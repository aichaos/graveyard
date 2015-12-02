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
# Yahoo Handler: message
#   Description: Handles Instant Messengers.

sub yahoo_message {
	my ($yahoo,$client,$msg) = @_;

	# Our screenname.
	my $sn = $yahoo->{username};
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Format the user's name.
	my $username = $client;
	$client = lc($client);
	$client =~ s/ //g;
	$client = 'YAHOO-' . $client;

	# Fix the message.
	if ($msg =~ /</i) {
		$msg =~ s/^<(.|\n)+?>//ig;
		$msg =~ s/^(.*?)</</i;
	}

	# Remove HTML from the message.
	$msg =~ s/<(.|\n)+?>//ig;

	# Save an original copy of the message.
	my $omsg = $msg;

	# Send this to the brain.
	my $reply = &on_im ($yahoo,$sn,$client,$msg,$omsg);
	my @out = split(/<:>/, $reply);

	# If not muted...
	if ($chaos->{clients}->{$client}->{mute} == 0) {
		# Send if these conditions aren't met.
		if ($reply ne '<notcommand>' && $reply !~ /^<noreply/i && $reply ne '<blocked>') {
			foreach my $send (@out) {
				# Filter things to avoid syntax errors.
				$send =~ s/\'/\\'/g;
				$username =~ s/\'/\\'/g;

				# Get our font.
				my ($font,$color,$style) = &get_font ($sn,'YAHOO');

				# Queue it.
				&queue ($sn,0,"\$chaos->{bots}->{'$sn'}->{client}->sendMessage ('$username','$send',"
					. "font => '$font', color => '$color', style => '$style');");
			}
		}
	}
}
{
	Type        => 'handler',
	Name        => 'yahoo_message',
	Description => 'Handles Yahoo Instant Messages.',
	Author      => 'Cerone Kirsle',
	Created     => '9:07 PM 4/16/2005',
	Updated     => '9:13 PM 4/16/2005',
	Version     => '1.0',
};