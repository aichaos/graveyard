#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !updates
#    .::   ::.     Description // Check for recent bot updates!
# ..:;;. ' .;;:..        Usage // !updates [new update]
#    .  '''  .     Permissions // Public [Admin Only]
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub updates {
	my ($self,$client,$msg,$listener) = @_;

	# Filter stuff.
	$msg =~ s/\&lt\;/</ig;
	$msg =~ s/\&gt\;/>/ig;
	$msg =~ s/\&amp\;/\&/ig;
	$msg =~ s/\&apos\;/'/ig;
	$msg =~ s/\&quot\;/"/ig;

	# If they're SETTING the updates...
	if ($msg) {
		# This is Master Only.
		if (isMaster($client,$listener)) {
			# If the message is "clear," updates will be cleared.
			if ($msg eq "clear") {
				# Unlink the updates.
				unlink ("./data/updates.txt");
				return "I have cleared all updates.";
			}
			else {
				# Set the updates to this.
				$msg =~ s/\n/<br>/ig;
				open (NEW, ">./data/updates.txt");
				print NEW $msg;
				close (NEW);

				$msg =~ s/<br>/\n/ig;

				return "I have set the updates:\n\n$msg";
			}
		}
		else {
			return "Setting updates is Master Only; if you would like to "
				. "see the updates, just use the command !updates but "
				. "don't put anything after the command.";
		}
	}

	# Send the recent updates.
	if (-e "./data/updates.txt" == 1) {
		open (UPDATES, "./data/updates.txt");
		my $updates = <UPDATES>;
		close (UPDATES);

		# Turn <BR> into \n again.
		$updates =~ s/<br>/\n/ig;

		return "<b>Recent Updates</b>\n\n"
			. "$updates";
	}
	else {
		return "<b>Recent Updates</b>\n\n"
			. "There are no new updates at this time.";
	}
}

{
	Category => 'Bot Utilities',
	Description => 'Recent Bot Updates',
	Usage => '!updates [new updates]',
	Listener => 'All',
};