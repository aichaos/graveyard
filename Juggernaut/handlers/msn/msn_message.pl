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
# Description: Handles incoming messages.

sub msn_message {
	# Get variables from the server.
	my ($self,$client,$name,$msg) = @_;

	# Get the local time and our handle.
	my $time = localtime();
	my $screenname = $self->{Msn}->{Handle};
	my $sn = lc($screenname);
	$sn =~ s/ //g;

	# Format the client's e-mail address.
	$client = lc($client);
	$client =~ s/ //g;

	# Save this current nickname for later use.
	$chaos->{$sn}->{current_user}->{nick} = $name;

	# Save an unformatted copy of the message.
	my $omsg = $msg;

	# Send this to the message handler.
	my $reply = on_im ($self,$screenname,$client,$msg,$omsg,"MSN");

	my @out = split (/\<\:\>/, $reply);

	# Send the reply if these conditions aren't met.
	if ($reply !~ /<notcommand>/i && $reply !~ /\<noreply/i && $reply !~ /<blocked>/i) {
		# See if we're muted.
		if ($chaos->{_users}->{$client}->{mute} == 0) {
			# Get the font.
			my ($font,$color,$style) = get_font ($screenname,"MSN");

			# Send each reply.
			foreach my $send (@out) {
				# Filter the reply for HTML. MSN doesn't support them.
				$send =~ s/<(.|\n)+?>//g;
				$send =~ s/\&lt\;/</ig;
				$send =~ s/\&gt\;/>/ig;
				$send =~ s/\&amp\;/&/ig;
				$send =~ s/\&quot\;/"/ig;
				$send =~ s/\&apos\;/'/ig;

				$self->sendtyping();
				sleep(1);
				$self->sendmsg ($send,Font => "$font",Color => "$color",Style => "$style");
			}
		}
	}
}
1;