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
# AIM Handler: aim_error
# Description: Handles AIM errors.

sub aim_error {
	# Get variables from the server.
	my ($aim,$conn,$error,$desc,$fatal) = @_;

	my $screenname = $aim->screenname();
	my $time = localtime();

	print "$time\n"
		. "ChaosAIM: Error $error: $desc\n"
		. "\tScreenName: $screenname\n"
		. "\tFatal: $fatal\n\n";

	my $sn = lc($screenname);
	$sn =~ s/ //g;

	# If this is a disconnection error...
	if ($desc =~ /lost connection to bos/i) {
		# If this bot was set to auto-reconnect.
		if ($chaos->{$sn}->{autoreconnect} == 1) {
			# If it's the CKS Server, we need to do things differently.
			if (-e "./chaos.id" == 1) {
				&panic ("Connection to AIM lost! Renewing IP address...", 0);
				# Renew the connection.
				system ("ipconfig /release");
				&panic ("IP Address Released. Renewing...", 0);
				sleep (5);
				system ("ipconfig /renew");
				&panic ("IP Address Renewed! Restarting the Bot...", 0);
				sleep (15);
				system ("start Juggernaut.bat");
				&panic ("Bot restarted!", 0);
				die "Disconnected -- Restarting";
			}

			# Wait 5 minutes and reconnect.
			print "ChaosAIM: $screenname reconnect scheduled in 5 minutes.\n\n";
			&dosleep (300);
			print "\aChaosAIM: Signing on $screenname (was disconnected)...\n\n";

			# Get the password.
			my $ok = 1;
			my $pw = $chaos->{$sn}->{password};

			# Resetup up the AIM bot.
			delete $chaos->{$sn}->{client};

			$chaos->{$sn}->{client} = Net::OSCAR->new(capabilities => [qw(typing_status buddy_icons)]);

			# Set up AIM handlers.
			$chaos->{$sn}->{client}->set_callback_admin_error (\&aim_admin_error);
			$chaos->{$sn}->{client}->set_callback_admin_ok (\&aim_admin_ok);
			$chaos->{$sn}->{client}->set_callback_auth_challenge (\&aim_auth_challenge);
			$chaos->{$sn}->{client}->set_callback_buddy_in (\&aim_buddy_in);
			$chaos->{$sn}->{client}->set_callback_buddy_info (\&aim_buddy_info);
			$chaos->{$sn}->{client}->set_callback_buddy_out (\&aim_buddy_out);
			$chaos->{$sn}->{client}->set_callback_buddylist_error (\&aim_buddylist_error);
			$chaos->{$sn}->{client}->set_callback_buddylist_ok (\&aim_buddylist_ok);
			$chaos->{$sn}->{client}->set_callback_chat_buddy_in (\&aim_chat_buddy_in);
			$chaos->{$sn}->{client}->set_callback_chat_buddy_out (\&aim_chat_buddy_out);
			$chaos->{$sn}->{client}->set_callback_chat_closed (\&aim_chat_closed);
			$chaos->{$sn}->{client}->set_callback_chat_im_in (\&aim_chat_im_in);
			$chaos->{$sn}->{client}->set_callback_chat_invite (\&aim_chat_invite);
			$chaos->{$sn}->{client}->set_callback_chat_joined (\&aim_chat_joined);
			$chaos->{$sn}->{client}->set_callback_error (\&aim_error);
			$chaos->{$sn}->{client}->set_callback_evil (\&aim_evil);
			$chaos->{$sn}->{client}->set_callback_im_in (\&aim_im_in);
			$chaos->{$sn}->{client}->set_callback_im_ok (\&aim_im_ok);
			$chaos->{$sn}->{client}->set_callback_rate_alert (\&aim_rate_alert);
			$chaos->{$sn}->{client}->set_callback_signon_done (\&aim_signon_done);

			$chaos->{$key}->{client}->set_callback_new_buddy_icon (\&aim_new_buddy_icon);
			$chaos->{$key}->{client}->set_callback_buddy_icon_uploaded (\&aim_buddy_icon_uploaded);
			$chaos->{$key}->{client}->set_callback_buddy_icon_downloaded (\&aim_buddy_icon_downloaded);
			$chaos->{$key}->{client}->set_callback_typing_status (\&aim_typing_status);

			# Sign on.
			$chaos->{$sn}->{client}->signon ($sn,$pw) or $ok = 0;

			print "ChaosAIM: $screenname reconnect: Success!\n\n" if $ok == 1;
			print "ChaosAIM: $screenname Reconnection Failure!\n\n" if $ok == 0;
		}
	}
}
1;