#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !define
#    .::   ::.     Description // Look up a word in Webster's Dictionary.
# ..:;;. ' .;;:..        Usage // !define <word>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub define {
	my ($self,$client,$msg,$listener) = @_;

	# Declare starting variables.
	my ($reply,$replya,$define,$definea);
	my $check = 0;
	my (@simp,@meaning);

	# Make sure they have something to define.
	if ($msg) {
		$def = get ("http://www.m-w.com/cgi-bin/dictionary?book=Dictionary&va=$msg");
		@simp = split(/\n/, $def);
		chomp @simp;

		$define = "Webster's Dictionary defines $msg as:\n";
		foreach $line (@simp) {
			if ($line =~ /^(Main Entry\:)/i) {
				$define .= "$line\n";
			}
			elsif ($line =~ /^(\<b\>1 a|\<b\>1)/i) {
				$definea .= "$line\n";
			}
		}
		($definea,$void) = split(/\<b\>2/, $definea);
		$define =~ s/<(.|\n)+?>//ig;
		$definea =~ s/<(.|\n)+?>//ig;

		$reply = $define . $definea;
	}
	else {
		$reply = "Invalid usage. Correct usage is:\n\n"
			. "!define [word]";
	}

	return $reply;
}

{
	Category => 'General Utilities',
	Description => 'Webster\'s Dictionary',
	Usage => '!define <word>',
	Listener => 'All',
};