#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !perlm
#    .::   ::.     Description // The old way of doing Perl commands (without STDOUT capture)
# ..:;;. ' .;;:..        Usage // !perlm <codes>
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub perlm {
	my ($self,$client,$msg,$listener) = @_;

	# The Perl command that captures output had a problem with
	# calling subroutines normally, so this command does it the
	# old fashioned way of not giving you the output of the
	# command. :P

	# Filter things.
	$msg =~ s/\&amp\;/\&/ig;
	$msg =~ s/\&lt\;/</ig;
	$msg =~ s/\&gt\;/>/ig;
	$msg =~ s/\&quot\;/"/ig;
	$msg =~ s/\&apos\;/'/ig;

	if (isMaster($client,$listener)) {
		# Eval the code.
		eval ($msg);

		return "I have executed the code:\n\n$msg";
	}
	else {
		return "This command can only be used by the botmaster.";
	}
}

{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Old !perl (no output)',
	Usage => '!perlm <commands>',
	Listener => 'All',
};