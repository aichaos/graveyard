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
# AIM Handler: evil                             #
# Description: Handles IM warnings.             #
#################################################

sub aim_evil {
	my ($aim,$level,$culprit) = @_;

	# Get the screenname and local time.
	my $screenname = $aim->screenname();
	my $time = localtime();

	# We'll handle IM's later, now we're just testing.
	print "$time\n";
	print "ChaosAIM: $screenname has been warned to $level\%.\n";

	# If this was done anonymously...
	if ($culprit eq "") {
		print "\tThe coward did this anonymously!\n";
		print "\tIt was probably $client.\n\n";
		$culprit = "anon";
	}
	else {
		print "\t$culprit did this! That little bastard!\n\n";
	}

	# If we know who did it, add the bitch to the warners list.
	if ($culprit ne "anon") {
		# Add this loser to the list.
		open (LIST, ">>./data/warners.txt");
		print LIST "$culprit\n";
		close (LIST);

		# Warn and block the prick.
		$aim->evil ($culprit, 0); # Once...
		$aim->evil ($culprit, 0); # Twice...
		$aim->evil ($culprit, 0); # Happy new year!
		$aim->add_deny ($culprit);
	}

	# Now that this is over with, we can get on with our "happy" little lives.
}
1;