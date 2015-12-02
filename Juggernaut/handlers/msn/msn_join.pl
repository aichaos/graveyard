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
# Description: Called when a user joins the conversation.

sub msn_join {
	# Get variables from the server.
	my ($self,$client,$name) = @_;

	# Get the local time and our handle.
	my $time = localtime();
	my $screenname = $self->{Msn}->{Handle};
	$screenname = lc($screenname);
	$screenname =~ s/ //g;

	print "ChaosMSN // Somebody Joined the Socket (\#" . $self->getID . "): $client\n\n";
	open (LOG, ">>./logs/$screenname\.txt");
	print LOG localtime(time) . "\n"
		. "ChaosMSN // $client joined socket: \#" . $self->getID . "\n\n";
	close (LOG);

	# Get the font.
	my ($font,$color,$style) = get_font ($screenname, "MSN");

	# If this is the MSN chat.
	if ($chaos->{$screenname}->{chat} eq $self) {
		$self->sendmsg ("Welcome to chat, $name!\n\n"
			. "The current chat topic is: $chaos->{$screenname}->{chat}->{topic}",
			Font => "$font",
			Color => "$color",
			Style => "$style",
		);
	}
	else {
		if ($chaos->{_system}->{config}->{msnchatallowed} == 0) {
			print "ChaosMSN: Left Socket (Join Handler) - Too Many People\n\n";
			$self->sendmsg ("I\'m sorry, but I am not allowed to join a multiple person "
				. "conversation that I didn\'t create.",
				Font  => "$font",
				Color => "$color",
				Style => "$style",
			);
			$self->leave ();
		}
	}
}
1;