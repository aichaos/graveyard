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
#  Subroutine: queue
# Description: Adds to the outgoing messages queue.

sub queue {
	# Get the data from the shifts.
	my ($time,$action) = @_;

	my $debug = 0;

	print "New Queue Received:\n"
		. "\tTime: $time\n"
		. "\tAction: $action\n\n" if $debug == 1;

	# If the queue exists...
	if (exists $chaos->{_system}->{queue}) {
		print "Added to end of queue!\n\n" if $debug == 1;
		# Add this to the end.
		push (@{$chaos->{_system}->{queue}}, "$time===$action");
	}
	else {
		print "Created the queue array!\n\n" if $debug == 1;
		$chaos->{_system}->{queue} = ["$time===$action"];
	}
}
1;