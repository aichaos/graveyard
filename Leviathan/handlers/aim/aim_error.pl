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
# AIM Handler: error
# Description: Handles AIM errors.

sub aim_error {
	my ($aim,$conn,$error,$desc,$fatal) = @_;

	# Get some data.
	my $screenname = $aim->screenname();
	my $time = &get_timestamp();
	my $sn = lc($screenname);
	$sn =~ s/ //g;

	print "$time\n"
		. "ChaosAIM: Error $error: $desc\n"
		. "\tScreenName: $screenname\n"
		. "\t     Fatal: $fatal\n\n";

	# If it was disconnected...
	if ($desc =~ /lost connection to bos/i) {
		# Return unless we want to reconnect.
		return unless $chaos->{bots}->{$sn}->{autoreconnect} == 1;

		print "$time\n"
			. "ChaosAIM: $screenname has been disconnected!\n"
			. "Reconnect scheduled in 5 minutes...\n\n";

		# A 5-minute wait.
		my $i;
		for ($i = 0; $i < 300; $i++) {
			&active ();
			sleep(1);
		}

		print "\a$time\n"
			. "ChaosAIM: Reconnecting $screenname to AIM...\n\n";

		# Delete the client, and begin recreating it.
		delete $chaos->{bots}->{$sn}->{client};
		my $key = $sn;

		# Create a new Net::OSCAR instance.
		$chaos->{bots}->{$key}->{client} = new Net::OSCAR (capabilities => [qw(typing_status buddy_icons)]);

		# Setup all the AIM handlers.
		$chaos->{bots}->{$key}->{client}->set_callback_admin_error (\&aim_admin_error);
		$chaos->{bots}->{$key}->{client}->set_callback_admin_ok (\&aim_admin_ok);
		$chaos->{bots}->{$key}->{client}->set_callback_auth_challenge (\&aim_auth_challenge);
		$chaos->{bots}->{$key}->{client}->set_callback_buddy_in (\&aim_buddy_in);
		$chaos->{bots}->{$key}->{client}->set_callback_buddy_info (\&aim_buddy_info);
		$chaos->{bots}->{$key}->{client}->set_callback_buddy_out (\&aim_buddy_out);
		$chaos->{bots}->{$key}->{client}->set_callback_buddylist_error (\&aim_buddylist_error);
		$chaos->{bots}->{$key}->{client}->set_callback_buddylist_ok (\&aim_buddylist_ok);
		$chaos->{bots}->{$key}->{client}->set_callback_chat_buddy_in (\&aim_chat_buddy_in);
		$chaos->{bots}->{$key}->{client}->set_callback_chat_buddy_out (\&aim_chat_buddy_out);
		$chaos->{bots}->{$key}->{client}->set_callback_chat_closed (\&aim_chat_joined);
		$chaos->{bots}->{$key}->{client}->set_callback_chat_im_in (\&aim_chat_im_in);
		$chaos->{bots}->{$key}->{client}->set_callback_chat_invite (\&aim_chat_invite);
		$chaos->{bots}->{$key}->{client}->set_callback_chat_joined (\&aim_chat_joined);
		$chaos->{bots}->{$key}->{client}->set_callback_error (\&aim_error);
		$chaos->{bots}->{$key}->{client}->set_callback_evil (\&aim_evil);
		$chaos->{bots}->{$key}->{client}->set_callback_im_in (\&aim_im_in);
		$chaos->{bots}->{$key}->{client}->set_callback_rate_alert (\&aim_rate_alert);
		$chaos->{bots}->{$key}->{client}->set_callback_signon_done (\&aim_signon_done);
		$chaos->{bots}->{$key}->{client}->set_callback_new_buddy_icon (\&aim_new_buddy_icon);
		$chaos->{bots}->{$key}->{client}->set_callback_buddy_icon_uploaded (\&aim_buddy_icon_uploaded);
		$chaos->{bots}->{$key}->{client}->set_callback_buddy_icon_downloaded (\&aim_buddy_icon_downloaded);
		$chaos->{bots}->{$key}->{client}->set_callback_typing_status (\&aim_typing_status);

		# Sign on the bot.
		my $password = $chaos->{bots}->{$key}->{password};

		$chaos->{bots}->{$key}->{client}->signon ($key,$password) or &panic ("Could not connect $key to AIM!",0);

		print "Connection received for $screenname!\n\n";
	}
}
{
	Type        => 'handler',
	Name        => 'aim_error',
	Description => 'Handles AIM errors.',
	Author      => 'Cerone Kirsle',
	Created     => '2:53 PM 11/20/2004',
	Updated     => '2:53 PM 11/20/2004',
	Version     => '1.0',
};