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
# IRC Handler: topic
# Description: Handles topic changes.

sub irc_topic {
	# Get data from the server.
	my ($self,$event) = @_;
	my @args = $event->args;

	my $stamp = &get_timestamp();

	if ($event->type eq 'notopic') {
		print "$stamp\n"
			. "ChaosIRC: No topic set for $args[1].\n\n";
	}
	elsif ($event->type eq 'topic' && $event->to) {
		print "$stamp\n"
			. "ChaosIRC: Topic change for " . $event->to . ": $args[0]\n\n";
	}
	else {
		print "$stamp\n"
			. "The topic for $args[1] is \"$args[2]\".\n\n";
	}
}
{
	Type        => 'handler',
	Name        => 'irc_topic',
	Description => 'Handles topic changes.',
	Author      => 'Cerone Kirsle',
	Created     => '2:23 PM 12/19/2004',
	Updated     => '2:23 PM 12/19/2004',
	Version     => '1.0',
};