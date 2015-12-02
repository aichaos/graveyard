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
# AIM Handler: aim_buddy_in
# Description: Called when a buddy (on the buddylist) signs on.

sub aim_buddy_in {
	# Get variables from the server.
	my ($aim,$client,$group,$data) = @_;

	my $screenname = $aim->screenname();
	my $time = localtime();

	# Format our screenname.
	$screenname = lc($screenname);
	$screenname =~ s/ //g;

	# If they're not already marked as online...
	if (!exists $chaos->{$screenname}->{_buddylist}->{online}->{$client}) {
		# Mark them as online.
		$chaos->{$screenname}->{_buddylist}->{online}->{$client} = 1;

		print "ChaosAIM: $client ($group) has just signed in.\n"
			. "\tScreenName: $screenname\n\n";
	}
}
1;