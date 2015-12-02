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
#    Sub-Type: GET
# Description: Return a Juggernaut response.

sub juggernaut_get {
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

	foreach my $key (keys %{$chaos->{$sn}->{_data}->{brain}}) {
		my $input = $key;
		if ($found == 0) {
			# Make sure this isn't the wildcard.
			if ($input eq '(.*)') {
				# Ignore.
			}
			else {
				if ($msg =~ /^$input$/) {
					$found = 1;

					my $potreply = $chaos->{$sn}->{_data}->{brain}->{$input};
					my @last = split(/\|/, $potreply);
					$reply = @last [ int(rand(scalar(@last))) ];

					# Filter stars into the response.
					my $star1 = lc($1) if $1;
					my $star2 = lc($2) if $2;
					my $star3 = lc($3) if $3;
					my $star4 = lc($4) if $4;
					my $star5 = lc($5) if $5;
					my $star6 = lc($6) if $6;
					my $star7 = lc($7) if $7;
					my $star8 = lc($8) if $8;
					my $star9 = lc($9) if $9;
					$reply =~ s/<star1>/$star1/ig if $star1;
					$reply =~ s/<star2>/$star2/ig if $star2;
					$reply =~ s/<star3>/$star3/ig if $star3;
					$reply =~ s/<star4>/$star4/ig if $star4;
					$reply =~ s/<star5>/$star5/ig if $star5;
					$reply =~ s/<star6>/$star6/ig if $star6;
					$reply =~ s/<star7>/$star7/ig if $star7;
					$reply =~ s/<star8>/$star8/ig if $star8;
					$reply =~ s/<star9>/$star9/ig if $star9;

					# Filter in special one-liners.
					$reply =~ s/<that1>/$thatone/ig;
					$reply =~ s/<that2>/$thattwo/ig;
					$reply =~ s/<that3>/$thatthree/ig;
					$reply =~ s/<client>/$client/ig;
					$reply =~ s/<listener>/$listener/ig;
					$reply =~ s/<date>/$date/ig;
					$reply =~ s/<time>/$secs/ig;

					# Let's see about any special tags.
					while ($reply =~ /<set>(.*)<\/set>/i) {
						my $wanted = $1;
						my ($style,$what,$is) = split(/=/, $wanted, 3);

						if ($style eq "formal") {
							$is = formal ($is);
						}
						else {
							$is = lc($is);
						}

						&profile_send ($client,$listener,$what,$is);
						$reply =~ s/<set>$1<\/set>/$is/i;
					}
					while ($reply =~ /<get>(.*)<\/get>/i) {
						my $trait = $1;
						$trait = lc($trait);
						$trait =~ s/ //g;
						$trait = $chaos->{_users}->{$client}->{$trait};
						$reply =~ s/<get>$1<\/get>/$trait/i;
					}
					while ($reply =~ /<bot>(.*)<\/bot>/i) {
						my $btrait = $1;
						$btrait = lc($btrait);
						$btrait =~ s/ //g;
						$btrait = $chaos->{$sn}->{data}->{$btrait};
						$reply =~ s/<bot>$1<\/bot>/$btrait/i;
					}
					while ($reply =~ /<system>(.*)<\/system>/i) {
						my $subby = $1;
						eval ($subby);
						$reply =~ s/<system>$1<\/system>//i;
					}
					while ($reply =~ /<random>(.*)<\/random>/i) {
						my $first_rand = $1;
						my @rand_choices = split(/\|/, $first_rand);
						my $this_rand = $rand_choices [ int(rand(scalar(@rand_choices))) ];
						$reply =~ s/<random>$first_rand<\/random>/$this_rand/ig;
					}
					while ($reply =~ /<formal>(.*)<\/formal>/i) {
						my $to_formal = $1;
						$to_formal = formal ($to_formal);
						$reply =~ s/<formal>$to_formal<\/formal>/$to_formal/ig;
					}
				}
			}
		}
	}

	if ($reply eq "") {
		# Now we call the wildcard.
		if (exists $chaos->{$sn}->{_data}->{brain}->{'(.*)'}) {
			my $potreply2 = $chaos->{$sn}->{_data}->{brain}->{'(.*)'};
			my @last2 = split(/\|/, $potreply2);
			$reply = @last2 [ int(rand(scalar(@last2))) ];
		}
		else {
			$reply = "Cannot reply to that.";
		}
	}

	# Return the response.
	return $reply;
}
1;