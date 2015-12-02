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
#  Subroutine: load_commands
# Description: Loads/Indexes All Commands.

sub load_commands {
	my $type = $chaos->{config}->{files}->{perl};
	my $name;

	my $reload = 0;
	$reload = 1 if exists $chaos->{system}->{commands};
	delete $chaos->{system}->{commands};

	# Get a list of all the command files.
	my @files = &scanDir('./commands',1,$type);

	foreach my $file (@files) {
		# Get command's data.
		my @parts = split(/\//, $file);
		my $name = pop(@parts);
		$name =~ s/\.($type)$//ig;

		# Include the command.
		$chaos->{system}->{commands}->{$name} = require "$file" if $reload == 0;
		$chaos->{system}->{commands}->{$name} = do "$file" if $reload == 1;
		print "\tIndexing command \"$name\"... Done!\n";
	}

	# Return true.
	return 1;
}
{
	Type        => 'subroutine',
	Name        => 'load_commands',
	Usage       => '&load_commands()',
	Description => 'Loads/indexes all command files.',
	Author      => 'Cerone Kirsle',
	Created     => '12:53 PM 11/20/2004',
	Updated     => '1:22 PM 3/26/2005',
	Version     => '1.1',
};