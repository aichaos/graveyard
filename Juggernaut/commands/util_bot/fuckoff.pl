#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !fuckoff
#    .::   ::.     Description // Entertaining way for the bot to shut up.
# ..:;;. ' .;;:..        Usage // !fuckoff
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // AIM, MSN
#     :     :        Copyright // 2004 Chaos AI Technology

sub fuckoff {
	# Get variables from the shift.
	my ($self,$client,$msg,$listener) = @_;

	$chaos->{_users}->{$client}->{mute} = 1;
	my ($sn,$font,$color,$style);
	if ($listener eq "AIM") {
		$sn = $self->screenname();
		$font = get_font ($sn,"AIM");

		sleep(2);
		$self->send_im ($client,$font . "Fucking off...");
		sleep(2);
		$self->send_im ($client,$font . "Fucked off...");
		sleep(2);
		$self->send_im ($client,$font . "See ya. Type !mute to talk again.");
		$reply = "Mute Mode: ON";
	}
	elsif ($listener eq "MSN") {
		$sn = $self->{Msn}->{Handle};
		($font,$color,$style) = get_font ($sn,"MSN");

		sleep(2);
		$self->sendmsg ("Fucking off...",
			Font => "$font",
			Color => "$color",
		);
		sleep(2);
		$self->sendmsg ("Fucked off...",
			Font => "$font",
			Color => "$color",
		);
		sleep(2);
		$self->sendmsg ("See ya. Type !mute to talk again.",
			Font => "$font",
			Color => "$color",
		);
		$reply = "Mute Mode: ON";
	}
	else {
		$reply = "This command only applies to instant messengers and will not effect "
			. "an HTTP conversation.";
	}

	return $reply;
}

{
	Category => 'Bot Utilities',
	Description => 'An alternative way to be muted',
	Usage => '!fuckoff',
	Listener => 'All',
};