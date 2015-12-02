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
#       Brain: Nexus
#    Sub-Type: GET
# Description: The primary Nexus brain's handler.

sub nexus_get {
	# Incoming data for the brain.
	my ($brain,$self,$client,$listener,$msg,$omsg,$sn) = @_;
	my $reply;

	$brain = lc($brain);
	$brain =~ s/ //g;

	$sn = lc($sn);
	$sn =~ s/ //g;

	my $found = 0;

	# Save some variables for latter use.
	my $date = localtime();
	my $secs = time();

	# Nexus is a learner, so let's see if it's a curse.
	return "<noreply>" if curses($msg);

	my $ignorant = 0;
	my $loops = 5;
	# Our main loop.
	nexus:

	# Only allow 5 loops.
	$loops--;
	if ($loops <= 0) {
		return "lol....";
	}

	my $last_msg = $chaos->{_users}->{$client}->{that2};

	# Turn their message into sentence case.
	$sentence = sentence ($msg);

	# See if we already know how to reply to this.
	open (OLD, $chaos->{$sn}->{reply});
	my @data = <OLD>;
	close (OLD);
	chomp @data;
	foreach my $line (@data) {
		my ($past,$present) = split(/\]\[/, $line, 2);
		if ($past eq "") {
			# The greetings line. Always on top.
			@presents = split(/\|/, $present);
			foreach $item (@presents) {
				if ($item eq $sentence) {
					$exists_greeting = 1;
				}
			}
		}
		if ($past eq $msg) {
			$exists_past = 1;
		}
		if (lc($last_msg) eq $past) {
			$exists_past_p = 1;
		}
		if ($present eq $sentence) {
			$exists_present = 1;
		}
	}

	# At this point, if it exists in the past and present, the
	# bot will not learn anything.

	# Is this your first message?
	if ($last_msg eq "") {
		# Yes it is!
		if ($exists_greeting == 0) {
			if ($ignorant == 0) {
				# This is a new greeting. Save it.
				$final = "";
				foreach $line (@data) {
					($past,$present) = split(/\]\[/, $line, 2);
					$past =~ s/[^\w\s]//g;
					if ($past eq "") {
						$present .= "|$sentence";
					}
					$final .= "$past][$present\n";
				}
				open (NEW, ">$chaos->{$sn}->{reply}");
				print NEW $final;
				close (NEW);

				$reply = "Hey! :-)";
			}
		}
		else {
			# Some simple reply matching.
			foreach $line (@data) {
				($past,$present) = split(/\]\[/, $line, 2);
				if ($msg =~ /$past/i) {
					@last = split(/\|/, $present);
					$reply = $last [ int(rand(scalar(@last))) ];
				}
			}
		}
	}
	else {
		# If this isn't their first message, start learning.
		if ($exists_past_p == 1) {
			# Their message will come as a random response then.
			if ($ignorant == 0) {
				$final = "";
				foreach $line (@data) {
					chomp $line;
					($past,$present) = split(/\]\[/, $line, 2);
					if (lc($past) eq lc($last_msg)) {
						$present .= "|$sentence";
						@last = split(/\|/, $present);
						$reply = $last [ int(rand(scalar(@last))) ];
					}
					$past =~ s/[^\w\s]//g;
					$final .= "$past][$present\n";
				}
				open (NEW, ">$chaos->{$sn}->{reply}");
				print NEW $final;
				close (NEW);
			}
		}
		else {
			if ($ignorant == 0) {
				# This is new.
				$last_msg = filter ($last_msg);
				$last_msg = lc($last_msg);
				$last_msg =~ s/[^\w\s]//g;
				open (NEW, ">>$chaos->{$sn}->{reply}");
				print NEW "$last_msg][$sentence\n";
				close (NEW);

				# And then... get a reply.
				$ignorant = 1;
				goto nexus;
			}
		}
	}

	# If we don't have a reply YET...
	if ($reply eq "") {
		$reply = "Let's change the subject.";
		print "CKS // An error occurred while getting Nexus reply.\n";
	}

	# Return the response.
	return $reply;
}
1;