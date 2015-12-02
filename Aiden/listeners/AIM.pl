# Listener: AIM

use Net::OSCAR qw(:standard);

{
	name      => 'AIM',
	init      => '$aiden->{bots}->{$sn}->{client} = new Net::OSCAR (capabilities => [ qw(typing_status buddy_icons)]);',
	handlers  => '$aiden->{bots}->{$sn}->{client}->set_callback_%CB% (%SUB%);',
	signon    => '$aiden->{bots}->{$sn}->{client}->signon ($sn,$pw);',
	callbacks => {
		admin_error     => 'aim_admin_error',
		buddy_in        => 'aim_buddy_in',
		buddy_out       => 'aim_buddy_out',
		chat_buddy_in   => 'aim_chat_buddy_in',
		chat_buddy_out  => 'aim_chat_buddy_out',
		chat_closed     => 'aim_chat_closed',
		chat_im_in      => 'aim_chat_im_in',
		chat_invite     => 'aim_chat_invite',
		chat_joined     => 'aim_chat_joined',
		error           => 'aim_error',
		evil            => 'aim_evil',
		im_in           => 'aim_im_in',
		rate_alert      => 'aim_rate_alert',
		signon_done     => 'aim_signon_done',
		buddy_icon_uploaded => 'aim_buddy_icon_uploaded',
	},
};