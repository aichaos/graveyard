#      .   .               <Leviathan>
#     .:...::     Command Name // !users
#    .::   ::.     Description // In-Depth User Stats
# ..:;;. ' .;;:..        Usage // !users
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub users {
	my ($self,$client,$msg) = @_;

	# Keep data.
	my %count = (
		aim => 0,
		msn => 0,
		irc => 0,
		http => 0,
		smtp => 0,
		yahoo => 0,
		jabber => 0,
	);

	# Count.
	foreach my $user (keys %{$chaos->{clients}}) {
		my ($lis,$name) = split(/\-/, $user, 2);
		$lis = 'Undefined' unless length $lis > 0;
		$lis = lc($lis);
		$lis =~ s/ //g;
		$lis = 'aim' if $lis eq 'toc';

		if (exists $count{$lis}) {
			$count{$lis}++;
		}
		else {
			$count{$lis} = 0;
		}
	}

	my $reply = "Clients Per Listener:\n\n"
		. "AIM/TOC: $count{aim}\n"
		. "MSN: $count{msn}\n"
		. "IRC: $count{irc}\n"
		. "HTTP: $count{http}\n"
		. "SMTP: $count{smtp}\n"
		. "Yahoo: $count{yahoo}\n"
		. "Jabber: $count{jabber}";
	delete $count{aim};
	delete $count{msn};
	delete $count{irc};
	delete $count{http};
	delete $count{smtp};
	delete $count{yahoo};
	delete $count{jabber};
	foreach my $key (keys %count) {
		$reply .= "\n" . uc($key) . ": $count{$key}";
	}
	return $reply;
}
{
	Category => 'Bot Utilities',
	Description => 'In-depth user statistics.',
	Usage => '!users',
	Listener => 'All',
};