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
#  Subroutine: modStars
# Description: Modify a user's stars.

sub modStars {
	# Get the needed data.
	my ($client,$type,$number) = @_;

	# Must be a supported type (+, -, =)
	if ($type ne '+' && $type ne '-' && $type ne '=') {
		&panic ("modStars // Invalid change type: $type",0);
		return 0;
	}

	# The number must be a number, not a string.
	if ($number =~ /[^0-9]/) {
		&panic ("modStars // Number was not numeric!",0);
		return 0;
	}

	# User must be formatted right, and must exist.
	my ($sender,$nick) = split(/\-/, $client, 2);
	$sender = uc($sender);
	$sender =~ s/ //g;
	$nick = lc($nick);
	$nick =~ s/ //g;
	if (not defined $nick) {
		&panic ("modStars // Client Nick Not Defined!",0);
		return 0;
	}
	if (!-e "./clients/$sender\-$nick\.txt") {
		&panic ("modStars // Client profile not found!",0);
		return 0;
	}
	$client = join ('-', $sender, $nick);

	# Get this user's stars.
	&profile_get ($client);
	my $stars = $chaos->{clients}->{$client}->{stars};

	# The maximum allowed stars is 9 trillian to the max.
	if (length $stars == 15) {
		# If it contains only 9's.
		if ($stars !~ /[^9]/) {
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
		$stars += $number;
	}
	elsif ($type eq '-') {
		$stars -= $number;
	}
	elsif ($type eq '=') {
		$stars = $number;
	}
	else {
		&panic ("modStars // Lost type.");
		return 0;
	}

	# Save the new stars.
	&profile_send ($client,"stars",$stars);

	# Return.
	return 1;
}
{
	Type        => 'subroutine',
	Name        => 'modStars',
	Usage       => '&modStars($client,$type,$number)',
	Description => 'Modify a user\'s stars.',
	Author      => 'Cerone Kirsle',
	Created     => '3:47 PM 5/26/2005',
	Updated     => '3:47 PM 5/26/2005',
	Version     => '1.0',
};