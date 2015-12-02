#      .   .               <Leviathan>
#     .:...::     Command Name // !report
#    .::   ::.     Description // Report an abusive user.
# ..:;;. ' .;;:..        Usage // !report <username>: <reason>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub report {
	my ($self,$client,$msg) = @_;

	# See that a user has been reported.
	return "You must provide a message to report!" unless length $msg > 0;

	# Report!
	my $stamp = &get_timestamp();
	open (REPORT, "./logs/reports.txt");
	print REPORT "$stamp\n"
		. "$client has reported: $msg\n\n";
	close (REPORT);

	return "I have left a report. It will be looked over by my master.";
}
{
	Category => 'Feedback',
	Description => 'Report an abusive user.',
	Usage => '!report <message>',
	Listener => 'All',
};