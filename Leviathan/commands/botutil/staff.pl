#      .   .               <Leviathan>
#     .:...::     Command Name // !staff
#    .::   ::.     Description // List the bot's staff.
# ..:;;. ' .;;:..        Usage // !staff
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub staff {
	my ($self,$client,$msg) = @_;

	# Load the staff files.
	my %files = (
		'moderators.txt' => [],
		'administrators.txt' => [],
		'master.txt' => [],
	);
	foreach my $file (keys %files) {
		open (DATA, "./data/authority/$file");
		my @data = <DATA>;
		close (DATA);
		chomp @data;

		my $exists = 0;
		foreach my $item (@data) {
			next if length $item == 0;
			if ($item =~ /^(MSN|JABBER)\-/i) {
				my $v;
				($item,$v) = split(/\@/, $item, 2);
				$item .= '@...';
			}
			$exists = 1;
			push (@{$files{$file}}, $item);
		}

		$files{$file} = [ '<i>None</i>' ] unless $exists;
	}

	my $mods = join ("\n", @{$files{'moderators.txt'}});
	my $admins = join ("\n", @{$files{'administrators.txt'}});
	my $master = join ("\n", @{$files{'master.txt'}});

	# Split up the replies if needed.
	my $reply = ".: Staff :.\n\n:: Moderators:\n"
		. "$mods\n\n"
		. ":: Admins:\n"
		. "$admins";
	if (length $reply > 1024) {
		$reply = ".: Staff :.\n\n:: Moderators:\n"
			. "$mods<:>"
			. ":: Admins:\n"
			. "$admins";
	}
	my $final = $reply . "\n\n"
		. ":: Botmasters:\n"
		. "$master";
	if (length $final > 1024) {
		$final = $reply . "<:>"
			. ":: Botmasters:\n"
			. "$master";
	}

	return $final;
}

{
	Category => 'Bot Utilities',
	Description => 'List the bot\'s staff members.',
	Usage => '!staff',
	Listener => 'All',
};