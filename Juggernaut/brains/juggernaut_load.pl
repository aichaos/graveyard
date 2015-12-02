#              ::.                   .:.
#               .;;:  ..:::::::.  .,;:
#                 ii;,,::.....::,;;i:
#               .,;ii:          :ii;;:
#    #######  ##, ,iii.         iii: .;,   #
#       #    ,#   ;iii.         iii;   :;. #
# .     #   ,,   ,#i###    ###  ;i#i; # ,#####
#  ::   #   i  :;i##;  #  #.  # .;#ii;#  ,,#     .:;
#   .,;#,,,;iiiiii#:   # ,#i: #   #;ii#i;;i#::,,;:
#    ##:,;iii;;;,.#    #;ii### #   ###;#iiii##,:
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
#       Brain: Juggernaut
#    Sub-Type: LOAD
# Description: Loads or reloads the Juggernaut replies.

sub juggernaut_load {
	# Incoming load-brain data (incase we need it).
	my ($bot,$brain,$dir) = @_;

	# If we have already loaded them, delete the hash.
	if (exists $chaos->{$bot}->{_data}->{brain}) {
		delete $chaos->{$bot}->{_data}->{brain};
	}

	# Make a few temporary variables.
	my $in_cat = 0;                           # If we're "in a category"
	my $cur_input;                            # Our current input.
	my $in_rep = 0;                           # If we're "in a reply"
	my ($s1,$s2,$s3,$s4,$s5,$s6,$s7,$s8,$s9); # Our star matches (9 max)
	my ($left,$right);

	# Load the reply data.
	opendir (DIR, "$dir");
	foreach my $file (sort(grep(!/^\./, readdir(DIR)))) {
		open (FILE, "$dir/$file");
		my @data = <FILE>;
		close (FILE);

		chomp @data;

		# Go through the data.
		foreach my $line (@data) {
			if ($line =~ /\<category\>/i) {
				$in_cat = 1;
			}
			elsif ($line =~ /\<\/category\>/i) {
				$in_cat = 0;
				$in_rep = 0;
				$cur_input = "";
			}
			else {
				# If we're in a category...
				if ($line =~ /^input/i) {
					# In the input area.
					$line =~ s/: /:/g;
					($left,$right) = split(/:/, $line, 2);
					$right =~ s/\*/(.*)/ig;

					$right = uc($right);
					$cur_input = $right;

					# Save this input.
					$chaos->{$bot}->{_data}->{brain}->{$right} = "";
				}
				elsif ($line =~ /^reply/i) {
					# If we have input to compare this to...
					if ($cur_input ne "") {
						# In the reply area.
						$line =~ s/: /:/g;
						($left,$right) = split(/:/, $line, 2);

						$right =~ s/\\n/\n/g;

						# Add this to our current input.
						if ($in_rep != 1) {
							$chaos->{$bot}->{_data}->{brain}->{$cur_input} .= "$right";
							$in_rep = 1;
						}
						else {
							$chaos->{$bot}->{_data}->{brain}->{$cur_input} .= "\n$right";
						}
					}
				}
			}
		}
	}
	closedir (DIR);

	my $count = 0;
	foreach my $key (keys %{$chaos->{$bot}->{_data}->{brain}}) {
		$count++;
	}

	# Save our reply count.
	$chaos->{$bot}->{_data}->{replycount} = $count;

	return 1;
}
1;