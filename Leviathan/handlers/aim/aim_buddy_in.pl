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
# AIM Handler: buddy_in
# Description: Called when a buddy signs in.

sub aim_buddy_in {
	my ($aim,$client,$group,$data) = @_;

	# Get some data.
	my $screenname = $aim->screenname();
	my $time = &get_timestamp();

	# Format the screenname.
	my $sn = lc($screenname);
	$sn =~ s/ //g;

	# If they're not already marked as online...
	if (!exists $chaos->{bots}->{$sn}->{_buddylist}->{online}->{$client}) {
		# Mark them online.
		$chaos->{bots}->{$sn}->{_buddylist}->{online}->{$client} = 1;

		# CKS Guardians: React if this user is being watched.
		if (exists $chaos->{bots}->{$sn}->{special}) {
			if ($chaos->{bots}->{$sn}->{special} eq 'AiChaos Guardians') {
				if ($group =~ /aichaos bots/i) {
					# An AiChaos Bot has just signed in... this is good.
					print "$time\n"
						. "Guardians: An AiChaos Bot, $client, has signed in.\n\n";
				}
				elsif ($group =~ /watch humans/i) {
					# A watched human. Grab their profile.
					$self->get_info ($client);

					# Alert Kirsle.
					$aim->send_im ('kirsle','<html><body bgcolor="#FFFFFF"><font face="Verdana" size="2" color="#000000">'
						. "A watched human, <b>$client</b>, has just signed in. A request for his profile "
						. "has been issued. Please check the <b>data/temp</b> folder for output.</font></body></html>");
				}
				elsif ($group =~ /watch bots/i) {
					# A watched bot. Grab their profile.
					$self->get_info ($client);

					# Alert Kirsle.
					$aim->send_im ('kirsle','<html><body bgcolor="#FFFFFF"><font face="Verdana" size="2" color="#000000">'
						. "A watched bot, <b>$client</b>, has just signed in. A request for its profile "
						. "has been issued. Please check the <b>data/temp</b> folder for output.</font></body></html>");

					# Chat with this bot; check for signs of copyright infringement.
					&guardian_botchat ($client);
				}
			}
			else {
				print "$time\n"
					. "ChaosAIM: $client ($group) has just signed in.\n"
					. "\tScreenName: $screenname\n\n";
			}
		}
	}
}
{
	Type        => 'handler',
	Name        => 'aim_buddy_in',
	Description => 'Called when a buddy signs in.',
	Author      => 'Cerone Kirsle',
	Created     => '2:14 PM 11/20/2004',
	Updated     => '2:14 PM 11/20/2004',
	Version     => '1.0',
};