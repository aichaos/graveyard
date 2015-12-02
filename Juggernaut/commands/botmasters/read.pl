#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !read
#    .::   ::.     Description // Read the contents of any file.
# ..:;;. ' .;;:..        Usage // !read <path to file>
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub read {
	my ($self,$client,$msg,$listener) = @_;

	# This command is Master Only.
	if (isMaster($client,$listener)) {
		# Make sure a file exists TO be read.
		if (length $msg > 0) {
			# See if this file exists.
			if (-e $msg == 1) {
				# Open the file.
				open (FILE, $msg);
				my @data = <FILE>;
				close (FILE);

				chomp @data;

				# Prepare it for sending.
				my $src;
				foreach my $line (@data) {
					# Shorten tabs to 2 spaces.
					$line =~ s/\t/  /g;

					$src .= "$line\n";
				}

				# Return the source.
				return $src;
			}
			else {
				return "That file was nowhere to be found, $chaos->{_users}->{$client}->{name}.";
			}
		}
		else {
			return "You need to put in a file for me to open! :-P";
		}
	}
	else {
		return "This command is Master Only!";
	}
}

{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Read the Contents of Any File',
	Usage => '!read <filepath>',
	Listener => 'All',
};