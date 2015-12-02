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
#  Subroutine: modPoints
# Description: Modify a user's points.

sub modPoints {
	# Get the needed data.
	my ($client,$type,$number) = @_;

	# Must be a supported type (+, -, =)
	if ($type ne '+' && $type ne '-' && $type ne '=') {
		&panic ("modPoints // Invalid change type: $type",0);
		return 0;
	}

	# The number must be a number, not a string.
	if ($number =~ /[^0-9]/) {
		&panic ("modPoints // Number was not numeric!",0);
		return 0;
	}

	# User must be formatted right, and must exist.
	my ($sender,$nick) = split(/\-/, $client, 2);
	$sender = uc($sender);
	$sender =~ s/ //g;
	$nick = lc($nick);
	$nick =~ s/ //g;
	if (not defined $nick) {
		&panic ("modPoints // Client Nick Not Defined!",0);
		return 0;
	}
	if (!-e "./clients/$sender\-$nick\.txt") {
		&panic ("modPoints // Client profile not found!",0);
		return 0;
	}
	$client = join ('-', $sender, $nick);

	# Get this user's points.
	&profile_get ($client);
	my $points = $chaos->{clients}->{$client}->{points};

	# The maximum allowed points is 9 trillian to the max.
	if (length $points == 15) {
		# If it contains only 9's.
		if ($points !~ /[^9]/) {
			# Return false if the type is an addition.
			return 0 if $type eq '+';
		}
	}

	# Can't set equal to a higher number than 9 trillian to the max.
	if ($type eq '=' && length $number > 15) {
		# Can't set equal to a number greater than 15 digits.
		return 0;
	}

	# Do the specified action.
	if ($type eq '+') {
		$points += $number;
	}
	elsif ($type eq '-') {
		$points -= $number;
	}
	elsif ($type eq '=') {
		$points = $number;
	}
	else {
		&panic ("modPoints // Lost type.");
		return 0;
	}

	# Save the new points.
	&profile_send ($client,"points",$points);

	# Return.
	return 1;
}
{
	Type        => 'subroutine',
	Name        => 'modPoints',
	Usage       => '&modPoints($client,$type,$number)',
	Description => 'Modify a user\'s points.',
	Author      => 'Cerone Kirsle',
	Created     => '1:01 PM 12/28/2004',
	Updated     => '1:01 PM 12/28/2004',
	Version     => '1.0',
};