#################################################
#                                               #
#     #####    #                                #
#    #     #   #                                #
#   #       #  #                                #
#  #           #            #                   #
#  #           ####     #####     ####    ####  #
#  #           #   #   #    #    #    #  #      #
#   #       #  #    #  #    #    #    #   ###   #
#    #     #   #    #  #    #    #    #      #  #
#     #####    #    #   #### ##   ####   ####   #
#                                               #
#         A . I .      T e c h n o l o g y      #
#-----------------------------------------------#
# AIM Handler: signon_done                      #
# Description: Called when signon is complete.  #
#################################################

sub aim_signon_done {
	my $aim = shift;

	# Get our screenname and localtime.
	my $screenname = $aim->screenname();
	my $time = localtime();

	# Set the Profile, Buddy List, & Buddy Icon.

	# Set the profile.
	open (PROFILE, $chaos->{$screenname}->{"profile"});
	my @profile = <PROFILE>;
	close (PROFILE);

	my $profile;
	foreach $line (@profile) {
		chomp $line;
		$profile .= $line;
	}
	$aim->set_info ($profile);

	# Set the buddy list.
	open (BUDDIES, $chaos->{$screenname}->{"buddies"});
	my @buddies = <BUDDIES>;
	close (BUDDIES);

	foreach $line (@buddies) {
		chomp $line;
		my ($group,$buddy) = split(/=/, $line);
		$aim->add_buddy ($group,$buddy);
	}

	# Send the buddy updates.
	$aim->commit_buddylist();
}
1;