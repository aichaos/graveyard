#      .   .               <Leviathan>
#     .:...::     Command Name // !say
#    .::   ::.     Description // I'll repeat what you say.
# ..:;;. ' .;;:..        Usage // !say <message>
#    .  '''  .     Permissions // Public.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub say {
	my ($self,$client,$msg) = @_;

	# Must be a message.
	return "I have nothing to repeat!" unless length $msg > 0;

	# Mix up the message so the bot won't say anything about itself.
	my @words = split(/\s+/, $msg);
	my @out = ();
	my $count = 0;
	foreach my $word (@words) {
		if ($word =~ /^i$/i) {
			$word = "you";
		}
		elsif ($word =~ /^you$/i) {
			$word = "I";
		}
		elsif ($word =~ /^my$/i) {
			$word = "your";
		}
		elsif ($word =~ /^your$/i) {
			$word = "my";
		}
		elsif ($word =~ /^are$/i) {
			$word = "am";
		}
		elsif ($word =~ /^am$/i) {
			$word = "are";
		}

		# Formalize it if it's the first word.
		if ($count == 0) {
			$word = ucfirst($word);
		}
		$count++;
		push (@out,$word);
	}

	$msg = CORE::join (" ", @out);
	return $msg;
}
{
	Category    => 'Fun Stuff',
	Description => 'I\'ll repeat what you say.',
	Usage       => '!say <message>',
	Listener    => 'All',
};