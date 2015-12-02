package CML::Util;

my $VERSION = "1.0";

=head1 NAME

CML General Utilities

=head1 DESCRIPTION

An add-on for the CML module that include functions such as formalization and other useful utilities.

=head1 USAGE

	use CML::Util;

	my $string = "the quick brown fox jumps over the lazy dog.";

	my $formal_string = CML::Util::formal ($string);

=head1 METHODS

=head2 formal

Formalizes a string (Initial Caps).

	my $formal_string = CML::Util::formal ($string);

=cut

sub formal {
	my $string = shift;

	# Split the words apart.
	my @words = split(/ /, $string);

	# Final array.
	my @final;

	# Formalize each word.
	foreach my $item (@words) {
		$item = lc($item);
		$item = ucfirst($item);

		push (@final,$item);
	}

	# Return the formal string.
	return join (" ", @final);
}

=head2 sentence

Sentence-case a string (Only the first word is formal.)

	my $sentence = CML::Util::sentence ($string);

=cut

sub sentence {
	my $string = shift;

	# Split the sentences apart.
	my @sentence = split(/(\.|\,|\?|\!)/, $string);

	my @final;

	# Go through each sentence.
	foreach my $item (@sentence) {
		$item = lc($item);
		$item = ucfirst($item);

		push (@final,$item);
	}

	return join (".", @final);
}

=head1 BUGS

Known bugs are:
- sentence() may not work right with multiple sentences, especially if the punctuation aren't all periods.

=cut

1;