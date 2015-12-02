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
# Description: Adds a queue.

sub queue {
	# Get the data.
	my ($sn,$expire,$code) = @_;

	print "New Queue Received:\n"
		. "\tScreenname: $sn\n"
		. "\tTime: $expire\n"
		. "\tAction: $code\n\n" if $chaos->{debug} == 1;

	# If the queue exists...
	if (exists $chaos->{system}->{queue}->{$sn}->{line}) {
		print "Added to end of queue!\n\n" if $chaos->{debug} == 1;

		# Add to the end.
		push (@{$chaos->{system}->{queue}->{$sn}->{line}}, "$expire===$code");
	}
	else {
		print "Created the queue for $sn!\n\n" if $chaos->{debug} == 1;
		$chaos->{system}->{queue}->{$sn}->{line} = [ "$expire===$code" ];
	}

	return 1;
}
{
	Type        => 'subroutine',
	Name        => 'queue',
	Usage       => '&queue($sn,$time,$code)',
	Description => 'Adds a queue.',
	Author      => 'Cerone Kirsle',
	Created     => '2:33 PM 11/20/2004',
	Updated     => '2:33 PM 11/20/2004',
	Version     => '1.0',
};