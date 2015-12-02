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
#  Subroutine: load_botfile
# Description: Loads the bot's profile (yep, bots have profiles too!)

sub load_botfile {
	my $bot = shift;

	# Get the bot's profile.
	if (!-e $chaos->{bots}->{$bot}->{data}) {
		&panic ("Bot $bot\'s profile does not exist!",0);
		return 1;
	}

	open (FILE, "$chaos->{bots}->{$bot}->{data}");
	my @data = <FILE>;
	close (FILE);
	chomp @data;

	foreach my $line (@data) {
		my ($what,$is) = split(/=/, $line, 2);
		$what = lc($what);
		$what =~ s/ //g;

		$chaos->{bots}->{$bot}->{_data}->{$what} = $is;
	}

	return 1;
}
{
	Type        => 'subroutine',
	Name        => 'load_botfile',
	Usage       => '&load_botfile ($screenname)',
	Description => 'Loads bot\'s profile data.',
	Author      => 'Cerone Kirsle',
	Created     => '1:13 PM 11/20/2004',
	Updated     => '1:13 PM 11/20/2004',
	Version     => '1.0',
};