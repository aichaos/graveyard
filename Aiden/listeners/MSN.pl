# Listener: MSN Messenger

use MSN;

{
	name      => 'MSN',
	init      => '$aiden->{bots}->{$sn}->{client} = MSN->new ('
		. 'Handle => $sn, Password => $pw, Debug => 0);'
		. '$aiden->{bots}->{$sn}->{client}->setClientCaps ('
		. '"Client-Name" => "AiChaos AidenBot/$aiden->{version}",'
		. '"Client-Type" => "BOT",'
		. '"Chat-Logging" => "Y");',
	handlers  => '$aiden->{bots}->{$sn}->{client}->setHandler (%CB% => %SUB%);',
	signon    => '$aiden->{bots}->{$sn}->{client}->connect();',
	callbacks => {
		Connected         => 'msn_connected',
		Disconnected      => 'msn_disconnect',
		ClientCaps        => 'msn_clientcaps',
		ContactAddingUs   => 'msn_add',
		ContactRemovingUs => 'msn_remove',
		Message           => 'msn_message',
		Typing            => 'msn_typing',
		Ring              => 'msn_ring',
		Answer            => 'msn_answer',
		MemberJoined      => 'msn_join',
		RoomClosed        => 'msn_close',
	},
};