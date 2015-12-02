# COMMAND NAME:
#	MUTE
# DESCRIPTION:
#	Toggles bot replies to you.
# COMPATIBILITY:
#	AIM, MSN

sub mute {
	my ($self,$client,$msg,$listener) = @_;

	# This command will switch on or off the "Mute" function.
	if ($chaos->{users}->{$client}->{mute} == 1) {
		$chaos->{users}->{$client}->{mute} = 0;

		$reply = "Thanks. I'll talk again.";
	}
	else {
		$chaos->{users}->{$client}->{mute} = 1;

		if ($listener eq "AIM") {
			my $screenname = $self->screenname();
			my $font = get_aim_font ($screenname);
			my $out = $font . "Alright, I'll stop talking to you.";
			sleep(2);
			$self->send_im ($client, $out);
		}
		elsif ($listener eq "MSN") {
			my $handle = $self->GetMaster->{Handle};
			my ($face,$color) = get_msn_font ($handle);
			$self->sendtyping();
			sleep(1);
			$self->sendmsg ("Alright, I'll stop talking to you.",Font => "$face",Color => "$color");
		}
	}

	return $reply;
}
1;