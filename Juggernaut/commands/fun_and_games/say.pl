#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !say
#    .::   ::.     Description // The bot will repeat what you tell it to.
# ..:;;. ' .;;:..        Usage // !say <message>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub say {
	# Get variables from the shift.
	my ($self,$client,$msg,$listener) = @_;

	return "No message to repeat." if length $msg == 0;

	$msg =~ s/\&lt\;/</ig;
	$msg =~ s/\&gt\;/>/ig;
	$msg =~ s/\&amp\;/&/ig;
	$msg =~ s/\&quot\;/"/ig;
	$msg =~ s/\&apos\;/'/ig;

	my @parts = split(/ /, $msg);
	my @result;
	foreach my $part (@parts) {
		my $lc = lc($part);

		if ($lc eq "i") { $part = "you"; }
		elsif ($lc eq "you") { $part = "I"; }
		elsif ($lc eq "am") { $part = "are"; }
		elsif ($lc eq "are") { $part = "am"; }

		push (@result, $part);
	}

	my $out = join (" ", @result);

	return $out;
}

{
	Category => 'Fun & Games',
	Description => 'Make the Bot Say What You Want',
	Usage => '!say <what>',
	Listener => 'All',
};