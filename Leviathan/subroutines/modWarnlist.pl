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
#  Subroutine: modWarnlist
# Description: Handles warners list.

sub modWarnlist {
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
		&panic ("Bad Warnlist Action: $action",0);
		return 0;
	}

	# See if they're on the warnlist first.
	my $warner = &isWarner($client);
	my $onWL = 0;
	if ($warner == 1) {
		$onWL = 1;
	}

	# Warnlist actions.
	if ($action eq 'add') {
		# Don't add if they're already there.
		return 0 if $onWL == 1;

		# Add to the warnlist.
		if (-e "./data/warners.txt") {
			open (APPEND, ">>./data/warners.txt");
			print APPEND "\n$client";
			close (APPEND);
		}
		else {
			open (CREATE, ">./data/warners.txt");
			print CREATE "$client";
			close (CREATE);
		}
		return 1;
	}
	else {
		# Remove from the warnlist.
		return 0 unless (-e "./data/warners.txt");

		# Don't remove if they're not there.
		return 0 if $onWL == 0;

		open (LOAD, "./data/warners.txt");
		my @list = <LOAD>;
		close (LOAD);
		chomp @list;

		my $found = 0;
		my @new;
		foreach my $line (@list) {
			my $check = $line;
			$check =~ s/\*/(.*?)/g;
			if ($client =~ /^$check$/i) {
				# Found!
				$found = 1;
			}
			else {
				push (@new, $line);
			}
		}

		open (SAVE, ">./data/warners.txt");
		print SAVE join ("\n", @new);
		close (SAVE);

		return 2;
	}

	return 0;
}
{
	Type        => 'subroutine',
	Name        => 'modWarnlist',
	Usage       => '&modWarnlist($action,$client)',
	Description => 'Handles warners list changes.',
	Author      => 'Cerone Kirsle',
	Created     => '12:13 PM 2/13/2005',
	Updated     => '12:13 PM 2/13/2005',
	Version     => '1.0',
};