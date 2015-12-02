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
#  Subroutine: isBlocked
# Description: Checks if the user is blocked.

sub isBlocked {
	# Get the user's name.
	my $client = shift;

	# Masters can NOT be blocked.
	return 0 if &isMaster ($client);

	my ($listener,$nick) = split(/\-/, $client, 2);

	# Get their info.
	open (INFO, "./clients/$client\.txt");
	my @info = <INFO>;
	close (INFO);
	chomp @info;

	my %profile;

	foreach my $line (@info) {
		my ($what,$is) = split(/=/, $line, 2);
		$what = lc($what);
		$what =~ s/ //g;

		$profile{$what} = $is;
	}

	print "Debug // Profile Data\n" if $chaos->{debug} == 1;
	foreach my $key (keys %$profile) {
		print "Debug // $key = $profile{$key}\n" if $chaos->{debug} == 1;
	}
	print "\n";

	# First, see if they have a temporary block.
	if ($profile{blocked} == 1) {
		# See if their sentence has expired.
		if (time() - $profile{expire} > 0) {
			&profile_send ($client,"blocked",0);
			&profile_send ($client,"expire",0);
			return (0,0);
		}

		print "Seconds Left: " . ($profile{expire} - time()) . "\n" if $chaos->{debug} == 1;
		my $left = ($profile{expire} - time()) / 60;
		print "Minutes Left: " . $left . "\n" if $chaos->{debug} == 1;

		# Only show to the tenths place.
		if ($left =~ /\./) {
			$left =~ s/\.(\d)(.*?)$/\.$1/ig;
		}

		return (1,"Temporary Block: $left minutes remaining.");
	}

	# Second, see if this user is one of our own.
	if (exists $chaos->{bots}->{$nick} && $listener =~ /^$chaos->{bots}->{$nick}->{listener}$/i) {
		return (1,'Looping Connection');
	}

	# Finally, check the blacklist.
	print "Debug // Checking Blacklist\n" if $chaos->{debug} == 1;
	open (LIST, "./data/blacklist.txt") or return (0,0);
	my @list = <LIST>;
	close (LIST);
	chomp @list;

	print "Debug // Blacklist Loaded!\n" if $chaos->{debug} == 1;

	foreach my $item (@list) {
		my ($usr,$reason) = split(/::/, $item, 2);
		$reason = 'undefined' unless defined $reason;
		if ($usr =~ /\*/i) {
			$usr =~ s/^(.*?)\-//i;
			$usr =~ s/\*/(.*?)/i;
		}

		print "\t\$item: $item (Reason: $reason)\n" if $chaos->{debug} == 1;

		if ($client =~ /^$usr$/i) {
			return (1,'Permanent Ban (BlackList). Reason: ' . $reason);
		}
	}

	# Bot detections... On MSN or Jabber, the e-mail would have the word "bot" in the NAME
	# part - on AIM and IRC, would probably end with "Bot"
	if ($listener eq 'MSN' || $listener eq 'JABBER') {
		my ($name,$domain) = split(/\@/, $client, 2);
		if ($name =~ /bot/i) {
			return (1,'Possibly a bot.');
		}
	}
	elsif ($listener eq 'AIM' || $listener eq 'IRC') {
		if ($client =~ /bot$/i) {
			return (1,'Possibly a bot.');
		}
	}

	return 0;
}
{
	Type        => 'subroutine',
	Name        => 'isBlocked',
	Usage       => '($blocked,$level) = &isBlocked($client)',
	Description => 'Checks if the user is blocked.',
	Author      => 'Cerone Kirsle',
	Created     => '1:58 PM 11/20/2004',
	Updated     => '1:58 PM 11/20/2004',
	Version     => '1.0',
};