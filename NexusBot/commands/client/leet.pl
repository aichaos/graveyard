# COMMAND NAME:
#	LEET
# DESCRIPTION:
#	Make your text l33t!
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub leet {
	my ($self,$client,$msg,$listener) = @_;

	# Leetify their text.
	if ($msg) {
		$msg = lc($msg);

		my @text = split(//, $msg);

		my $result;
		foreach $symbol (@text) {
			$symbol =~ s/a/4/ig;
			$symbol =~ s/b/B/ig;
			$symbol =~ s/c/C/ig;
			$symbol =~ s/d/D/ig;
			$symbol =~ s/e/3/ig;
			$symbol =~ s/f/F/ig;
			$symbol =~ s/g/G/ig;
			$symbol =~ s/h/H/ig;
			$symbol =~ s/i/1/ig;
			$symbol =~ s/j/J/ig;
			$symbol =~ s/k/K/ig;
			$symbol =~ s/l/L/ig;
			$symbol =~ s/m/M/ig;
			$symbol =~ s/n/N/ig;
			$symbol =~ s/o/0/ig;
			$symbol =~ s/p/P/ig;
			$symbol =~ s/q/Q/ig;
			$symbol =~ s/r/R/ig;
			$symbol =~ s/s/5/ig;
			$symbol =~ s/t/7/ig;
			$symbol =~ s/u/U/ig;
			$symbol =~ s/v/V/ig;
			$symbol =~ s/w/W/ig;
			$symbol =~ s/x/X/ig;
			$symbol =~ s/y/Y/ig;
			$symbol =~ s/z/2/ig;
			$result .= $symbol;
		}

		$reply = "Your text L33T1F13D: $result";
	}
	else {
		$reply = "To l33t1fy your text type: !leet [text]";
	}

	return $reply;
}
1;