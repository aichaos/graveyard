#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !tz
#    .::   ::.     Description // Set Your Time Zone
# ..:;;. ' .;;:..        Usage // !tz
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub tz {
	my ($self,$client,$msg,$listener) = @_;

	# Set the callback.
	$chaos->{_users}->{$client}->{callback} = 'tz';

	# If they already have a time zone...
	if ($chaos->{_users}->{$client}->{time} ne 'undefined') {
		if ($chaos->{_users}->{$client}->{_tz}->{step} == 1) {
			if ($msg =~ /y/i) {
				# Delete their time zone.
				&profile_send ($client,$listener,'time','undefined');

				delete $chaos->{_users}->{$client}->{_tz}->{step};
				delete $chaos->{_users}->{$client}->{callback};

				return "Your time zone has been erased. To reset your time "
					. "zone, use the !tz command again.";
			}
			else {
				delete $chaos->{_users}->{$client}->{_tz}->{step};
				delete $chaos->{_users}->{$client}->{callback};

				return "Your time zone has been left alone.";
			}
		}
		else {
			$chaos->{_users}->{$client}->{_tz}->{step} = 1;
			return "You already have a time zone set: $chaos->{_users}->{$client}->{time}\n\n"
				. "Do you want to change your time zone? <lt>yes|no<gt>";
		}
	}
	else {
		# New time zone!
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

		if ($chaos->{_users}->{$client}->{_tz}->{step} == 1) {
			# If they already set their time zone...
			if ($msg =~ /^zone (.*?)$/i) {
				$msg = $1;
				$msg = uc($msg);
				$msg =~ s/ //g;

				# If it exists.
				if (exists $zones{$msg}) {
					&profile_send ($client,$listener,"time",$msg);
				}
				else {
					my $tz_record = join ("\n", keys %zones);
					return "We do not have that time zone on record. The time "
						. "zones we have are:\n"
						. $tz_record;
				}
			}
			else {
				# Get their message data.
				my ($time,$ext) = split(/ /, $msg);
				my ($hours,$mins) = split(/:/, $time);

				# If this is AM/PM...
				if ($ext =~ /^(am|pm)$/i) {
					if ($hours != 12) {
						$hours += 12 if $ext =~ /^pm$/i;
					}
				}

				# Find out how far off this is.
				my ($secs,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime();

				my $difference;
				if ($hour > $hours) {
					$difference = $hours - $hour;
				}
				else {
					$difference = $hour - $hours;
				}

				print "Debug // Time Offset: $difference\n";

				# Find a key.
				foreach my $key (keys %zones) {
					if ($zones{$key} == $difference) {
						&profile_send ($client,$listener,"time",$key);
						delete $chaos->{_users}->{$client}->{callback};
						delete $chaos->{_users}->{$client}->{_tz};
						return "Your time zone is $key right?";
					}
				}

				delete $chaos->{_users}->{$client}->{callback};
				delete $chaos->{_users}->{$client}->{_tz};
				return "I could not determine your time zone. Please go to "
					. "http://www.timeanddate.com/library/abbreviations/timezones/na/"
					. " and find the time zone that relates to you, and use the !tz "
					. "command and then tell me \"zone (your time zone)\".";
			}
		}
		else {
			$chaos->{_users}->{$client}->{_tz}->{step} = 1;
			return "We're about to figure out your time zone. If you already know "
				. "your time zone, type \"zone <lt>time zone code<gt>\", for "
				. "example: zone EST\n\n"
				. "If you don't know your time zone, we can compare your clock "
				. "time to GMT time. Tell me your clock's time in military format "
				. "(24 hours) or 12 hour format (with AM or PM). Examples:\n"
				. "13:42\n"
				. "1:42 PM\n\n"
				. "Tell me what your clock says.";
		}
	}
}

{
	Category => 'Bot Utilities',
	Description => 'Find your Time Zone',
	Usage => '!tz',
	Listener => 'All',
};