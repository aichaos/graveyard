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
# CYAN Handler: private
#  Description: Private messages.

sub cyan_private {
	my ($self,$nick,$level,$addr,$msg) = @_;

	# Get some data.
	my $screenname = $self->nick();
	my $time = &get_timestamp();

	my $sn = lc($screenname);
	$sn =~ s/ //g;

	# Format the username.
	my $client = lc($nick);
	$client =~ s/ //g;
	$client = 'CYAN-' . $client;

	# Save an original copy.
	my $omsg = $msg;

	# Reply.
	my $reply = &on_im ($self,$sn,$client,$msg,$omsg);
	my @out = split(/<:>/, $reply);

	# If not muted...
	if ($chaos->{clients}->{$client}->{mute} != 1) {
		if ($reply ne '<notcommand>' && $reply !~ /<noreply/i && $reply ne '<blocked>') {
			my @send = reverse(@out);
			foreach my $go (@send) {
				my @lines = split(/\n/, $go);
				my @line2 = reverse(@lines);
				foreach my $line (@line2) {
					$self->sendPrivate ($nick,$line);
				}
			}
		}
	}
}
{
	Type        => 'handler',
	Name        => 'cyan_private',
	Description => 'Private messages.',
	Author      => 'Cerone Kirsle',
	Created     => '3:43 PM 5/14/2005',
	Updated     => '3:44 PM 5/14/2005',
	Version     => '1.0',
};