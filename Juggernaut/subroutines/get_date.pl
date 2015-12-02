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
#  Subroutine: get_date
# Description: Gets the current local date.

sub get_date {
	# The requested type.
	my ($for,$stamp,$zone) = @_;

	$for ||= "local";

	# Arrays.
	my @days = qw (Sunday Monday Tuesday Wednesday Thursday Friday Saturday);
	my @a_days = qw (Sun Mon Tues Wed Thur Fri Sat);
	my @months = qw (January February March April May June July August September October November December);
	my @a_mon = qw (Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);

	# Declare time variables.
	my ($secs,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst);

	my ($local_date,$local_time,$gm_date,$gm_time,$user_date,$user_time);

	# Local, Client, or GM?
	if ($for eq 'local') {
		($secs,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	}
	elsif ($for eq 'gm') {
		($secs,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime(time);
	}
	elsif ($for eq 'zone') {
		if (length $zone == 0) {
			&panic ("get_date: No zone sent for Zone Time!",0);
			return 0;
		}

		($secs,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime(time);

		# The Time Zones.
		my %zones = (
			GMT => 0,
			NST => -3.5,
			NDT => -2.5,
			AST => -4,
			ADT => -3,
			EST => -5,
			EDT => -4,
			CST => -6,
			CDT => -5,
			MST => -7,
			MDT => -6,
			PST => -8,
			PDT => -7,
			AKST => -9,
			AKDT => -8,
			HAST => -10,
			HADT => -9,
		);

		# Get their time offset.
		if (exists $zones{$zone}) {
			my $offset = $zones{$zone};
		}
		else {
			&panic ("Could not find offset for zone $zone",0);
			return 0;
		}

		# Include the offset.
		$hour += $offset;

		# If it's negative...
		if ($hour < 0) {
			# Add 24 hours.
			$hour += 24;
		}
	}
	else {
		&panic ("get_date: Invalid Request For: $for",0);
		return 0;
	}

	# Number fixing.
	$year += 1900;
	$secs = '0' . $secs if length $secs == 1;
	$min  = '0' . $min  if length $min  == 1;
	my $short_year = $year;
	$short_year =~ s/^..//ig;

	# Format the data.
	my $hour12 = $hour;
	my $ext = 'AM';
	$ext = 'PM' if $hour >= 12;
	$hour12 -= 12 if $hour12 > 12;

	# Filter in timestamps.
	$stamp =~ s/<day_name>/$days[$wday]/ig;
	$stamp =~ s/<day_abbrev>/$a_days[$wday]/ig;
	$stamp =~ s/<day_month>/$mday/ig;
	$stamp =~ s/<day_year>/$yday/ig;
	$stamp =~ s/<month_name>/$months[$mon]/ig;
	$stamp =~ s/<month_abbrev>/$a_mon[$mon]/ig;
	$stamp =~ s/<year_full>/$year/ig;
	$stamp =~ s/<year_short>/$year_short/ig;
	$stamp =~ s/<hour_12>/$hour12/ig;
	$stamp =~ s/(<hour>|<hour_24>)/$hour/ig;
	$stamp =~ s/<min>/$min/ig;
	$stamp =~ s/<secs>/$secs/ig;
	$stamp =~ s/<ext>/$ext/ig;

	# Return the timestamp.
	return $stamp;
}
1;