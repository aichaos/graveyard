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
#  Subroutine: timestamps
# Description: Filters in time stamps.

sub timestamps {
	# The requested type.
	my ($for,$stamp,$zone) = (shift,shift,shift);

	$for ||= "local";

	# Time types:
	#    local == Your local time.
	#    gm    == Greenwich Metric Time.
	#    zone  == A user's time zone (if you included $zone, it would
	#             do that time zone anyway).

	if ($for =~ /^gm/i) {
		$zone = 'GMT';
	}

	# Go for backwards compatibility.
	$stamp =~ s/<month_name>/Month/ig;
	$stamp =~ s/<month_abbrev>/Mon/ig;
	$stamp =~ s/<month_num>/m\{on\}/ig;
	$stamp =~ s/<day_name>/Weekday/ig;
	$stamp =~ s/<day_abbrev>/Day/ig;
	$stamp =~ s/<day_month>/d/ig;
	$stamp =~ s/<day_year>//ig;
	$stamp =~ s/<year_full>/yyyy/ig;
	$stamp =~ s/<year_short>/yy/ig;
	$stamp =~ s/<hour_12>/H/ig;
	$stamp =~ s/<hour_24>/h/ig;
	$stamp =~ s/<hour_ext>/AM/ig;
	$stamp =~ s/<ext>/AM/ig;
	$stamp =~ s/(<minutes>|<min>)/mm/ig;
	$stamp =~ s/(<seconds>|<secs>)/ss/ig;

	# Modules used for getting date/time.
	use Time::Local;
	use Time::Format qw(time_format);
	use Time::Zone;

	# Find the time() according to GMT.
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime(time());
	my $gm = Time::Local::timelocal ($sec,$min,$hour,$mday,$mon,$year);
	$gm = time() unless defined $zone;

	# Format the time.
	if (defined $zone) {
		my $offset = tz_offset($zone);
		$gm += $offset;
	}
	my $format = time_format ($stamp,$gm);
	return $format;
}
{
	Type        => 'subroutine',
	Name        => 'timestamps',
	Usage       => '$stamp = &timestamps ($for,$stamp,$zone)',
	Description => 'Returns time stamps.',
	Author      => 'Cerone Kirsle',
	Created     => '2:04 PM 11/20/2004',
	Updated     => '1:44 PM 3/26/2005',
	Version     => '1.1',
};