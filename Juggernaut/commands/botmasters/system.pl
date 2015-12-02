#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !system
#    .::   ::.     Description // Execute system commands.
# ..:;;. ' .;;:..        Usage // !system <commands>
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub system {
	my ($self,$client,$msg,$listener) = @_;

	# This command is SOO master only.
	if (isMaster($client,$listener)) {
		# Start a counter.
		if (exists $chaos->{_data}->{syscount}) {
			$chaos->{_data}->{syscount}++;
		}
		else {
			$chaos->{_data}->{syscount} = 0;
		}
		my $count = $chaos->{_data}->{syscount};
		my $file = "system_" . $count . ".txt";

		# If they have something to evaluate.
		if (length $msg > 0) {
			# Do it.
			system ("$msg > ./data/temp/$file");
			sleep(1);
			open (LOG, "./data/temp/$file");
			my @reply = <LOG>;
			close (LOG);
			return "I have executed the system function.\n\n@reply";
		}
		else {
			return "You must provide a command to execute.";
		}
	}
	else {
		return "This command is Master Only.";
	}
}

{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Execute System Commands',
	Usage => '!system',
	Listener => 'All',
};