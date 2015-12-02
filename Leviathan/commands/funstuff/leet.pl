#      .   .               <Leviathan>
#     .:...::     Command Name // !leet
#    .::   ::.     Description // Make your text l33t.
# ..:;;. ' .;;:..        Usage // !leet <text>
#    .  '''  .     Permissions // Public.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub leet {
	my ($self,$client,$msg) = @_;

	# Leetify their text.
	if (length $msg > 0) {
		$msg = uc($msg);

		my @text = split(//, $msg);

		my $result;
		foreach $symbol (@text) {
			$symbol =~ s/a/4/ig;
			$symbol =~ s/e/3/ig;
			$symbol =~ s/i/1/ig;
			$symbol =~ s/o/0/ig;
			$symbol =~ s/s/5/ig;
			$symbol =~ s/t/7/ig;
			$symbol =~ s/z/2/ig;
			$result .= $symbol;
		}

		$reply = "Your text L33T1F13D: $result";
	}
	else {
		$reply = "To l33t1fy your text type: !leet <lt>text<gt>";
	}

	return $reply;
}
{
	Category    => 'Fun Stuff',
	Description => 'Make your text l33t.',
	Usage       => '!leet <text>',
	Listener    => 'All',
};