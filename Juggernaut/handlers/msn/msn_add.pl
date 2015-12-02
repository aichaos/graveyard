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
# MSN Handler: add
# Description: Called when a contact adds us to their list.

sub msn_add {
	# Get variables from the server.
	my ($notify,$client) = @_;

	# Get the handle.
	my $sn = $notify->{Msn}->{Handle} or &panic ("Could not get handle!",0);
	$sn = lc($sn);
	$sn =~ s/ //g;

	# See if our contact list is full.
	my @users = $chaos->{$sn}->{client}->getContactList ('AL') or 0;

	print '<' . localtime(time) . '>'
		. "\n"
		. "ChaosMSN: $client has added the bot ($sn) to their list!\n";

	# The limit is... 600?
	if (scalar(@users) >= 600) {
		print "ChaosMSN: Addition was denied: Allow List is Full!\n\n";
		# Send a message...
		$chaos->{$sn}->{client}->call ($client,'Sorry :-( My allow list is full. Ask whoever you got my '
			. 'e-mail from if I have any mirrors, and add those to your list instead. :-)');
		return 0;
	}
	else {
		print "ChaosMSN: Addition allowed!\n\n";
		return 1;
	}
}
1;