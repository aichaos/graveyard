#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !mute
#    .::   ::.     Description // Makes the bot stop talking to you.
# ..:;;. ' .;;:..        Usage // !mute
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub mute {
	# Get variables from the shift.
	my ($self,$client,$msg,$listener) = @_;

	# See if they're already being muted.
	if ($chaos->{_users}->{$client}->{mute} == 1) {
		$chaos->{_users}->{$client}->{mute} = 0;
		$reply = "Thanks. :-) I'll talk again.";
	}
	else {
		$chaos->{_users}->{$client}->{mute} = 1;
		my ($sn,$font,$color,$style);
		if ($listener eq "AIM") {
			$sn = $self->screenname();
			$font = get_font ($sn,"AIM");

			$self->send_im ($client,$font . "Alright, just type !mute when you want me to talk again!");
			$reply = "Mute Mode: ON";
		}
		elsif ($listener eq "MSN") {
			$sn = $self->{Msn}->{Handle};
			($font,$color,$style) = get_font ($sn,"MSN");

			$self->sendmsg ("Alright, just type !mute when you want to talk again!",
				Font => "$font",
				Color => "$color",
			);
			$reply = "Mute Mode: ON";
		}
		else {
			$reply = "This command only applies to instant messengers and will not effect "
				. "an HTTP conversation.";
		}
	}

	return $reply;
}

{
	Category => 'Bot Utilities',
	Description => 'Toggle the Bot to Talk to You',
	Usage => '!mute',
	Listener => 'All',
};