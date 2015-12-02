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
# IRC Handler: irc_pm
# Description: Handles incoming private messages.

sub irc_pm {
	# Get variables from the server.
	my ($self,$event) = @_;
	my $nick = $event->nick;
	my @msg = $event->args();
	my $msg = join ("", @msg);

	# Get our localt time.
	my $sn = $self->nick;
	my $time = localtime();
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Format the nickname.
	$client = lc($nick);
	$client =~ s/ //g;
	$client = "IRC_$client";

	# Filter the message for HTML.
	$msg =~ s/<(.|\n)+?>//g;

	# Save an unformatted copy of the message.
	my $omsg = $msg;

	# Send this data to the IM handler.
	my $reply = on_im ($self,$sn,$client,$msg,$omsg,"IRC");

	my @out = split(/\<\:\>/, $reply);

	# See if they're muted.
	if ($chaos->{_users}->{$client}->{mute} == 0) {
		# Send if these conditions aren't met.
		if ($reply !~ /<notcommand>/i && $reply !~ /<noreply>/i && $reply !~ /<blocked>/i) {
			foreach my $send (@out) {
				$self->privmsg ($nick,$send);
			}
		}
	}
}
1;