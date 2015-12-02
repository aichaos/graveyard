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
#  Subroutine: profile_send
# Description: Send a profile item.

sub profile_send {
	# Data from the shifts.
	my ($client,$var,$value) = @_;

	# Save this value locally, too.
	my $lcvar = lc($var);
	$lcvar =~ s/ //g;
	$chaos->{clients}->{$client}->{$lcvar} = $value;

	# Only if their profile exists.
	return 0 unless (-e "./clients/$client\.txt");

	# Open it.
	open (SRC, "./clients/$client\.txt");
	my @data = <SRC>;
	close (SRC);
	chomp @data;

	my @new = ();
	my $match = lc($var);
	$match =~ s/ //g;
	my $found = 0;

	foreach my $line (@data) {
		if (length $line == 0) {
			push (@new, '');
			next;
		}

		my ($what,$is) = split(/=/, $line, 2);
		my $left = lc($what);
		$left =~ s/ //g;

		my $newline;
		if ($match eq $left) {
			$found++;
			$newline = "$var=$value";
		}
		else {
			$newline = "$what=$is";
		}

		push (@new, $newline);
	}

	# If there was an error...
	if ($found == 0) {
		# Add this value.
		push (@new, "$var=$value");
		print "\n\n*** PROFILE_SEND // Variable $var ($value) added! ***\n\n";
	}
	elsif ($found == 1) {
		# Okay.
	}
	else {
		print "\n\n*** PROFILE_SEND // Matched Multiple Items! ***\n\n";
		return 0;
	}

	# Save the new profile.
	open (SAVE, ">./clients/$client\.txt");
	print SAVE join ("\n", @new);
	close (SAVE);
	return 1;
}
{
	Type        => 'subroutine',
	Name        => 'profile_send',
	Usage       => '&profile_send($client,$var,$value)',
	Description => 'Send a profile item.',
	Author      => 'Cerone Kirsle',
	Created     => '8:55 AM 11/21/2004',
	Updated     => '8:55 AM 11/21/2004',
	Version     => '1.0',
};