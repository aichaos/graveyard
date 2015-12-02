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
# AIM Handler: buddy_info
# Description: Called in response to a buddy info request.

sub aim_buddy_info {
	my ($aim,$client,$data) = @_;

	# Get some data.
	my $screenname = $aim->screenname();
	my $time = &get_timestamp();

	# Format the screenname.
	my $sn = lc($screenname);
	$sn =~ s/ //g;

	# Profile getting count.
	if (exists $chaos->{bots}->{$sn}->{_profile_get}) {
		$chaos->{bots}->{$sn}->{_profile_get}++;
	}
	else {
		$chaos->{bots}->{$sn}->{_profile_get} = 0;
	}

	my $id = $chaos->{bots}->{$sn}->{_profile_get};

	# Get the profile.
	my $profile = $data->{profile};

	# Save this profile.
	open (PROFILE, ">./data/temp/userinfo" . $id . ".html");
	print PROFILE $profile;
	close (PROFILE);
}
{
	Type        => 'handler',
	Name        => 'aim_buddy_info',
	Description => 'Called in response to a buddy info request.',
	Author      => 'Cerone Kirsle',
	Created     => '2:18 PM 11/20/2004',
	Updated     => '2:18 PM 11/20/2004',
	Version     => '1.0',
};