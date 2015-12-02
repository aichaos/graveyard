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
# TOC Handler: im_in
# Description: Handles instant messages.

sub toc_im_in {
	my ($aim,$evt,$from,$to) = @_;
	my ($client,$away,$msg) = @{$evt->args};

	# Get localtime and username.
	my $stamp = &get_timestamp();
	my $sn = $aim->{botscreenname};
	$sn = lc($sn);
	$sn =~ s/ //g;

	# If it's an automessage...
	if ($away == 1) {
		$msg =~ s/<(.|\n)+?>//g;
		print "$stamp\n"
			. "ChaosTOC: Automessage from $client: $msg\n\n";
	}
	else {
		# Format the username.
		$client = lc($client);
		$client =~ s/ //g;
		my $username = $client;
		$client = 'TOC-' . $client;

		# Filter out HTML from the message.
		$msg =~ s/<(.|\n)+?>//g;

		# Save an original copy of the message.
		my $omsg = $msg;

		# Send this to the brain and get a reply.
		my $reply = &on_im ($aim,$sn,$client,$msg,$omsg);

		my @out = split(/<:>/, $reply);

		# If not muted...
		if ($chaos->{clients}->{$client}->{mute} != 1) {
			# Send if these conditions aren't met.
			if ($reply ne '<notcommand>' && $reply !~ /<noreply/i && $reply ne '<blocked>') {
				foreach my $send (@out) {
					if ($send !~ /<font/i) {
						my $font = &get_font ($sn,'AIM');
						$send = $font . $send;
					}

					# Avoid syntax errors.
					$send =~ s/\'/\\'/g;

					# Queue the outgoing message.
					&queue ($sn,3,"\$chaos->{bots}->{'$sn'}->{client}->send_im ('$username', '$send');");
				}
			}
		}
	}
}
{
	Type        => 'handler',
	Name        => 'toc_im_in',
	Description => 'Handles instant messages.',
	Author      => 'Cerone Kirsle',
	Created     => '1:07 PM 2/6/2005',
	Updated     => '1:07 PM 2/6/2005',
	Version     => '1.0',
};