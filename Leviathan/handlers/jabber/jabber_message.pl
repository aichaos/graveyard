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
# Jabber Handler: message
#    Description: Handles incoming messages.

sub jabber_message {
	my ($jabber,$screenname,$session,$message) = @_;

	my $sn = lc($screenname);
	$sn =~ s/ //g;

	$jabber->{username} = $sn;

	# Get data.
	my $from = $message->GetFrom() || '';
	my $type = $message->GetType() || '';
	my $msg  = $message->GetBody() || '';

	return if length $msg == 0;

	my ($client,$resource) = ( $from =~ /(.*?\@.*?)\/(.*)$/ ) ? ( $1, $2 ) : ( $from, '' );

	# Format the user's name.
	my $username = $client;
	$client = lc($client);
	$client =~ s/ //g;
	$client = 'JABBER-' . $client;

	# Save an original copy of the message.
	my $omsg = $msg;

	# Send this to the brain.
	my $reply = &on_im ($jabber,$sn,$client,$msg,$omsg);

	my @out = split(/<:>/, $reply);

	# If not muted...
	if ($chaos->{clients}->{$client}->{mute} == 0) {
		# Send if these conditions aren't met.
		if ($reply ne '<notcommand>' && $reply !~ /^<noreply/i && $reply ne '<blocked>') {
			foreach my $send (@out) {
				# Filter things to avoid syntax errors.
				$send =~ s/\'/\\'/g;
				$username =~ s/\'/\\'/g;

				$send =~ s/\&lt\;/</g;
				$send =~ s/\&gt\;/>/g;
				$send =~ s/\&quot\;/"/g;
				$send =~ s/\&apos\;/'/g;

				# Add this to the queue.
				&queue ($sn,0,"\$chaos->{bots}->{'$sn'}->{client}->MessageSend ("
					. "to => '$username',"
					. "type => 'chat',"
					. "body => '$send' );");
			}
		}
	}
}
{
	Type        => 'handler',
	Name        => 'jabber_message',
	Description => 'Handles Jabber messages.',
	Author      => 'Cerone Kirsle',
	Created     => '3:05 PM 12/2/2004',
	Updated     => '3:06 PM 12/2/2004',
	Version     => '1.0',
};