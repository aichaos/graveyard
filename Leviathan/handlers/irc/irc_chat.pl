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
# IRC Handler: chat
# Description: Handles public chat.

sub irc_chat {
	# Get data from the server.
	my ($self,$event) = @_;
	my $sock = ($event->to)[0];
	my $client = $event->nick;
	my @msg = $event->args();
	my $msg = join (" ", @msg);

	# Get localtime and our nick.
	my $stamp = &get_timestamp();
	my $sn = $self->nick;
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Format the nickname.
	my $user = $client;
	$client = lc($client);
	$client =~ s/ //g;
	$client = 'IRC-' . $client;

	# Save an unformatted message copy.
	my $omsg = $msg;

	# Send this to the IM handler.
	my $reply = &on_im ($self,$sn,$client,$msg,$omsg);

	my @out = split(/(\n|<:>)/, $reply);

	# If not muted...
	if ($chaos->{clients}->{$client}->{mute} == 0) {
		# Send if these conditions aren't met.
		if ($reply !~ /<notcommand>/i && $reply !~ /<noreply/i && $reply !~ /<blocked>/i) {
			foreach my $send (@out) {
				$self->privmsg ($user,$send);
			}
		}
	}
}
{
	Type        => 'handler',
	Name        => 'irc_chat',
	Description => 'Handles chat messages.',
	Author      => 'Cerone Kirsle',
	Created     => '2:06 PM 12/19/2004',
	Updated     => '2:06 PM 12/19/2004',
	Version     => '1.0',
};