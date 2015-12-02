#      .   .               <Leviathan>
#     .:...::     Command Name // !screnglish
#    .::   ::.     Description // Scramble the English
# ..:;;. ' .;;:..        Usage // !screnglish <sentence>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub screnglish {
	my ($self,$client,$msg) = @_;

	return "Under construction . . .";

	return "Command usage:\n\n"
		. "!screnglish some sentence\n"
		. "!screnglish some sentence<lt>-<gt>left\n"
		. "!screnglish some sentence<lt>-<gt>right\n\n"
		. "Default direction: right" unless length $msg > 0;

	$msg =~ s/\&lt\;/</g;
	$msg =~ s/\&gt\;/>/g;

	# Arguments.
	my ($text,$dir) = split(/<\->/, $msg, 2);
	$dir = 'r' unless defined $dir;

	if ($dir =~ /^r/i || $dir =~ /^l/i) {
		# Get the words.
		my @words = split(/\s+/, $text);
		my @finish = ();
		foreach my $word (@words) {
			# Split the characters.
			my @chars = split(//, $word);

			my ($first,$last) = ('','');

			# Right (default), first and last positions intact.
			if ($dir =~ /^r/i) {
				$first = shift(@chars);
				$last  = pop(@chars);
			}
			else {
				$first = pop(@chars);
				$last  = shift(@chars);
			}

			# Shuffle the array.
			my $i;
			for ($i = @chars; --$i; ) {
				my $j = int rand ($i+1);
				next if $i == $j;
				$chars[$i,$j] = $chars[$j,$i];
			}
			my $new = $first . join('',@chars) . $last;
			push (@finish,$new);
		}

		# Return it.
		return join (" ", @finish);
	}
	else {
		return "Improper usage:\n\n"
			. "!screnglish my sentence\n"
			. "!screnglish my sentence<lt>-<gt>left\n"
			. "!screnglish my sentence<lt>-<gt>right\n\n"
			. "Right is default.";
	}
}
{
	Category => 'Fun Stuff',
	Description => 'Scramble your English',
	Usage => '!screnglish <sentence> [<->(left|right)]',
	Listener => 'All',
};