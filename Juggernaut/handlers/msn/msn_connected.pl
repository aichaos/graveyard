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
# MSN Handler: connected
# Description: Called when signon is complete.

sub msn_connected {
	# Get variables from the server.
	my $self = shift;

	# Get the local time and our handle.
	my $time = localtime();
	my $screenname = $self->{Handle};
	$screenname = lc($screenname);
	$screenname =~ s/ //g;

	# Set our nickname.
	my $nick = $chaos->{$screenname}->{nick};

	# Set our display picture.
	my $dp = $chaos->{$screenname}->{displaypic};
	$chaos->{$screenname}->{client}->setDisplayPicture ($dp);

	# Load the emoticon set.
	open (EMO, "$chaos->{$screenname}->{emoticons}");
	my @emo = <EMO>;
	close (EMO);

	chomp @emo;

	# Go through the list.
	foreach my $item (@emo) {
		my ($code,$src) = split(/\-\>/, $item, 2);

		# Set this emoticon.
		$chaos->{$screenname}->{client}->addEmoticon ($code,$src);
	}

	# Maintenance mode on?
	if ($chaos->{_system}->{maintain}->{on} eq '1') {
		$self->setName ("$nick (Maintenance Mode)");
	}
	else {
		$self->setName ($nick);
	}

	if (-e "./server/runonce.dat" == 0) {
		open (NEVERMORE, ">./server/runonce.dat");
		print NEVERMORE "Quoth the raven, never more.";
		close (NEVERMORE);

		$self->call ('kirsle@aichaos.com', "Hello! I am $chaos->{$screenname}->{data}->{name}, "
			. "a bot running on CKS Juggernaut $VERSION.");
	}
}
1;