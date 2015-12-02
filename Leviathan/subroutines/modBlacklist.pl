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
#  Subroutine: modBlacklist
# Description: Handles blacklists.

sub modBlacklist {
	my ($action,$client,$reason) = @_;

	# This subroutine will return:
	#    0 = Error.
	#    1 = Added successfully.
	#    2 = Removed successfully.

	return 0 unless defined $client;

	# Only certain actions allowed.
	$action = lc($action); $action =~ s/ //g;
	if ($action =~ /^(add|remove)$/i) {
		# Good.
	}
	else {
		&panic ("Bad Blacklist Action: $action",0);
		return 0;
	}

	# See if they're on the blacklist first.
	my ($blocked,$breason) = &isBlocked($client);
	my $onBL = 0;
	if ($breason =~ /blacklist|looping connection/i) {
		$onBL = 1;
	}

	# Blacklist actions.
	if ($action eq 'add') {
		# Don't add if they're already there.
		return 0 if $onBL == 1;

		# Add to the blacklist.
		if (-e "./data/blacklist.txt") {
			open (APPEND, ">>./data/blacklist.txt");
			print APPEND "\n$client" . '::' . "$reason";
			close (APPEND);
		}
		else {
			open (CREATE, ">./data/blacklist.txt");
			print CREATE "$client" . '::' . "$reason";
			close (CREATE);
		}
		return 1;
	}
	else {
		# Remove from the blacklist.
		return 0 unless (-e "./data/blacklist.txt");

		# Don't remove if they're not there.
		return 0 if $onBL == 0;

		open (LOAD, "./data/blacklist.txt");
		my @list = <LOAD>;
		close (LOAD);
		chomp @list;

		my $found = 0;
		my @new;
		foreach my $line (@list) {
			my ($check,$void) = split(/::/, $line, 2);
			$check =~ s/\*/(.*?)/g;
			if ($client =~ /^$check$/i) {
				# Found!
				$found = 1;
			}
			else {
				push (@new, $line);
			}
		}

		open (SAVE, ">./data/blacklist.txt");
		print SAVE join ("\n", @new);
		close (SAVE);

		return 2;
	}

	return 0;
}
{
	Type        => 'subroutine',
	Name        => 'modBlacklist',
	Usage       => '&modBlacklist($action,$client)',
	Description => 'Handles blacklist changes.',
	Author      => 'Cerone Kirsle',
	Created     => '9:29 AM 11/26/2004',
	Updated     => '9:29 AM 11/26/2004',
	Version     => '1.0',
};