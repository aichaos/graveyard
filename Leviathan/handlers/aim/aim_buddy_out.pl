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
# AIM Handler: buddy_out
# Description: Called when a buddy signs out.

sub aim_buddy_out {
	my ($aim,$client,$group) = @_;

	# Get some data.
	my $screenname = $aim->screenname();
	my $time = &get_timestamp();

	# Format the screenname.
	my $sn = lc($screenname);
	$sn =~ s/ //g;

	# No longer online.
	delete $chaos->{bots}->{$sn}->{_buddylist}->{online}->{$client};

	# CKS Guardians: React if this user is being watched.
	if ($chaos->{bots}->{$sn}->{special} eq 'AiChaos Guardian') {
		if ($group =~ /aichaos bots/i) {
			# An AiChaos bot has crashed!
			# Restart Leviathan.
			system ("start perl Leviathan.pl /s");
			sleep (10);
			exit(0);
		}
		elsif ($group =~ /watch humans/i) {
			# A watched human has signed out.
			print "$time\n"
				. "Guardians: $client, a watched human, has just signed out.\n\n";
		}
		elsif ($group =~ /watch bots/i) {
			# A watched bot has signed out.
			print "$time\n"
				. "Guardians: $client, a watched bot, has just signed out.\n\n";
		}
	}
	else {
		print "$time\n"
			. "ChaosAIM: $client ($group) has signed out.\n"
			. "\tScreenName: $screenname\n\n";
	}
}
{
	Type        => 'handler',
	Name        => 'aim_buddy_out',
	Description => 'Called when a buddy signs out.',
	Author      => 'Cerone Kirsle',
	Created     => '2:15 PM 11/20/2004',
	Updated     => '2:15 PM 11/20/2004',
	Version     => '1.0',
};