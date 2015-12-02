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
#  Subroutine: isMaster
# Description: Checks if the user is a master.

sub isMaster {
	# Get the user's name.
	my $client = shift;

	# Get the list and go through it.
	open (LIST, "./data/authority/master.txt");
	my @list = <LIST>;
	close (LIST);
	chomp @list;

	foreach my $item (@list) {
		return 1 if $client eq $item;
	}

	if (exists $chaos->{clients}->{$client}->{_failsafe}) {
		return 1;
	}

	return 0;
}
{
	Type        => 'subroutine',
	Name        => 'isMaster',
	Usage       => '$master = &isMaster($client)',
	Description => 'Checks if the user is a master.',
	Author      => 'Cerone Kirsle',
	Created     => '4:10 PM 11/20/2004',
	Updated     => '7:13 AM 1/12/2005',
	Version     => '1.0',
};