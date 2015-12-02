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
#  Subroutine: load_userdata
# Description: Loads userdata for all users.

sub load_userdata {
	# Get all the user data!
	my $type = $chaos->{config}->{files}->{clients};
	print "Debug // Client File Type: $type\n" if $chaos->{debug} == 1;
	opendir (CLIENTS, "./clients");
	foreach my $client (sort(grep(!/^\./, readdir(CLIENTS)))) {
		print "\tDebug // On File: $client\n" if $chaos->{debug} == 1;
		next unless $client =~ /\.($type)$/i;

		print "\tDebug // Loading Userfile \"$client\"...\n" if $chaos->{debug} == 1;

		open (FILE, "./clients/$client");
		my @data = <FILE>;
		close (FILE);
		chomp @data;

		my $username = $client;
		$username =~ s/\.($type)$//ig;

		foreach my $line (@data) {
			next if length $line == 0;
			my ($what,$is) = split(/=/, $line, 2);
			$what = lc($what);
			$what =~ s/ //g;

			$chaos->{clients}->{$username}->{$what} = $is;
		}
	}
	closedir (CLIENTS);

	# Return true.
	return 1;
}
{
	Type        => 'subroutine',
	Name        => 'load_userdata',
	Usage       => '&load_userdata()',
	Description => 'Loads userdata for all users.',
	Author      => 'Cerone Kirsle',
	Created     => '12:46 PM 11/20/2004',
	Updated     => '12:46 PM 11/20/2004',
	Version     => '1.0',
};