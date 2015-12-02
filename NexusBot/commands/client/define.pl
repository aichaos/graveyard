# COMMAND NAME:
#	DEFINE
# DESCRIPTION:
#	Looks up a definition at Webster's Dictionary.
# COMPATIBILITY:
#	FULLY COMPATIBLE

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
		$definea =~ s/<(.|\n)+?>//ig;

		$reply = $define . $definea;
	}
	else {
		$reply = "Invalid usage. Correct usage is:\n\n"
			. "!define [word]";
	}

	return $reply;
}
1;