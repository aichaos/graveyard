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
#  Subroutine: log_im
# Description: Logs the IM's recieved.

sub log_im {
	# Get variables from the shift.
	my ($client,$msg,$sn,$reply,$listener) = @_;

	# Only log if we're not masked.
	if ($chaos->{_users}->{$client}->{_mask} != 1) {
		# Get the timestamp.
		my $stamp = $chaos->{_system}->{config}->{timestamp} || '<day_abbrev> <month_abbrev> <day_month> <hour_24>:<min>:<secs> <year_full>';

		# Get the time.
		$stamp = &get_date ('local',$stamp);

		# Make sure the folders exist.
		my $type = "Chaos" . $listener;
		if (-e "./logs/$type" == 0) {
			mkdir ("./logs/$type");
		}

		my $time = localtime();

		# Save this in the overall conversation log.
		open (TTL, ">>./logs/$sn.txt");
		print TTL "$stamp\n"
			. "[$client] $msg\n"
			. "[$sn] $reply\n\n";
		close (TTL);

		# Save this in this user's personal file.
		open (PER, ">>./logs/$type/$client.txt");
		print PER "$stamp\n"
			. "[$client] $msg\n"
			. "[$sn] $reply\n\n";
		close (PER);

		# And of course... print it to the console!
		print "$stamp\n"
			. "$type: [$client] $msg\n"
			. "$type: [$sn] $reply\n\n";
	}
}
1;