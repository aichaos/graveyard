# Listener: YAHOO

use Net::YIM;

{
	name      => 'YAHOO',
	init      => '$aiden->{bots}->{$sn}->{client} = new Net::YIM (username => $sn, password => $pw);',
	handlers  => '$aiden->{bots}->{$sn}->{client}->setHandler (%CB% => %SUB%);',
	signon    => '$aiden->{bots}->{$sn}->{client}->connect();',
	callbacks => {
		Connected => 'yahoo_connected',
		Message   => 'yahoo_message',
	},
};