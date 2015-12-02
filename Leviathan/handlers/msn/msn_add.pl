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
# Description: Handles a contact adding us.

sub msn_add {
	my ($notify,$client) = @_;

	# Get our handle.
	my $sn = $notify->{Msn}->{Handle};
	$sn = lc($sn);
	$sn =~ s/ //g;

	# See if the contact list isn't full.
	my @users = $chaos->{bots}->{$sn}->{client}->getContactList ('AL') or 0;

	my $stamp = &get_timestamp();
	print "$stamp\n"
		. "ChaosMSN: $client has added the bot ($sn) to their contact list.\n";

	# The limit is 600.
	if (scalar(@users) >= 600) {
		print "ChaosMSN: Addition was denied (list is full)\n\n";

		# Send a message...
		$chaos->{bots}->{$sn}->{client}->call ($client, 'Sorry. :-( My Allow List is full. Ask whoever '
			. 'you got my e-mail from if I have any mirrors, and add those to your list instead! :-)',
			Font  => 'Verdana',
			Color => '000000',
			Style => 'B',
		);
		return 0;
	}
	else {
		print "ChaosMSN: Addition allowed!\n\n";
		return 1;
	}
}
{
	Type        => 'handler',
	Name        => 'msn_add',
	Description => 'Handles a contact adding us.',
	Author      => 'Cerone Kirsle',
	Created     => '9:39 AM 11/21/2004',
	Updated     => '9:39 AM 11/21/2004',
	Version     => '1.0',
};