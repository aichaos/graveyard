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
# AIM Handler: aim_buddy_info
# Description: Called in response to $aim->get_info().

sub aim_buddy_info {
	# Get variables from the server.
	my ($aim,$client,$data) = @_;

	# Get the local time and our screenname.
	my $time = localtime();
	my $screenname = $aim->screenname();
	$screenname = lc($screenname);
	$screenname =~ s/ //g;

	# Our profile getting count.
	if (exists $chaos->{$screenname}->{profile_get}) {
		$chaos->{$screenname}->{profile_get}++;
	}
	else {
		$chaos->{$screenname}->{profile_get} = 0;
	}

	my $id = $chaos->{$screenname}->{profile_get};

	# Get the profile and away message.
	my $profile = $data->{profile};
	my $away = $data->{awaymsg};

	# Save this profile.
	open (PROFILE, ">./data/temp/userinfo" . $id . ".html");
	print PROFILE "$away<hr>$profile";
	close (PROFILE);
}
1;