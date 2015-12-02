#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !users
#    .::   ::.     Description // More in-depth user statistics.
# ..:;;. ' .;;:..        Usage // !users
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub users {
	my ($self,$client,$msg,$listener) = @_;

	my %users;

	# Open the users directory.
	opendir (USR, "./clients");
	foreach my $file (sort(grep(!/^\./, readdir(USR)))) {
		next if -d "./clients/$file";
		next unless $file =~ /\.txt$/i;

		# It's only the listener we want.
		my ($l,$c) = split(/\-/, $file, 2);

		$l = "undefined" if length $l == 0;

		# New messenger?
		$users{$l} = 0 unless exists $users{$l};

		# Add to the count.
		$users{$l}++;
	}
	closedir (USR);

	# Return the count.
	my $reply = ".: Users Per Listener :.\n\n";
	foreach my $key (keys %users) {
		$reply .= "$key: $users{$key}\n";
	}
	return $reply;
}

{
	Category => 'General',
	Description => 'In-depth User Statistics',
	Usage => '!users',
	Listener => 'All',
};