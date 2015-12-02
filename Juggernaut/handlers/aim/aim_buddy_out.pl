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
# AIM Handler: aim_buddy_out
# Description: Called when a buddy (on the buddylist) signs off.

sub aim_buddy_out {
	# Get variables from the server.
	my ($aim,$client,$group) = @_;

	my $screenname = $aim->screenname();
	my $time = localtime();

	# Format our screenname.
	$screenname = lc($screenname);
	$screenname =~ s/ //g;

	# They are no longer online.
	delete $chaos->{$screenname}->{_buddylist}->{online}->{$client};

	print "ChaosAIM: $client ($group) has signed off.\n"
		. "\tScreenName: $screenname\n\n";
}
1;