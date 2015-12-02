# Listener: HTTP

use HTTP::Daemon;
use HTTP::Status;
use HTTP::Headers;
use URI::Escape;

{
	name      => 'HTTP',
	init      => '$aiden->{bots}->{$sn}->{client} = HTTP::Daemon->new(LocalAddr => $sn, LocalPort => $pw, Timeout => 0.1)',
	handlers  => '',
	signon    => '',
	callbacks => {
	},
};