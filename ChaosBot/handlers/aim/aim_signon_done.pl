# AIM Handler: signon_done
# Called when signon is completed.

sub aim_signon_done {
	# Get server arguments from the shift.
	my ($aim) = @_;

	my $time = localtime();

	my $screenname = $aim->screenname();

	# We'll have to reload our information.
	my $is_my_file = 0;
	my $profile_path;
	my $buddies_path;

	opendir(DIR, "./bots");
	foreach $file (sort(grep(!/^\./, readdir(DIR)))) {
		#$file =~ s/\.(.*)//g;

		open (BOT, "./bots/$file");
		my @bot_data = <BOT>;
		close (BOT);

		foreach $line (@bot_data) {
			chomp $line;
			$line =~ s/: /:/g;
			($what,$is) = split(/:/, $line);

			$what =~ s/ //g;
			$what = lc($what);

			if ($what eq "screenname" && $is eq $screenname) {
				# We have a screenname.
				$is_my_file = 1;
			}
			elsif ($what eq "screenname" && $is ne $screenname) {
				# This isn't us.
				$is_my_file = 0;
			}
			elsif ($what eq "profile" && $is_my_file == 1) {
				# Time to set the password.
				$profile_path = $is;
			}
			elsif ($what eq "buddies" && $is_my_file == 1) {
				# The client it connects to.
				$buddies_path = $is;
			}
			else {
			}
		}
	}
	closedir(DIR);

	# Get AIM profile.
	open (FILE, "$profile_path");
	my @profile = <FILE>;
	close (FILE);

	# Get AIM Buddies.
	open (BUDDIES, "$buddies_path");
	my @buddies = <BUDDIES>;
	close (BUDDIES);

	# Go through the profile and buddy list.
	my $profile;
	foreach $line (@profile) {
		chomp $line;
		$profile .= "$line";
	}
	foreach $line (@buddies) {
		chomp $line;
		my ($group,$buddy) = split(/=/, $line);
		$aim->add_buddy($group,$buddy);
	}

	$profile =~ s/\<\!--//g;
	$profile =~ s/--\>//g;

	$config{"ad_html"} = ("<font face=\"Verdana,Arial\" size=\"2\" color=\"red\">" . $config{"ad_html"});

	$aim->set_info ($profile . $config{"ad_html"});

	if ($config{"sendlist"} == 1) {
		$aim->commit_buddylist ();
	}

	print "$time\n";
	print "ChaosAIM: $screenname has signed on.\n";
}
1;