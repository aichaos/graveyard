#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !love
#    .::   ::.     Description // The Love Test!
# ..:;;. ' .;;:..        Usage // !love <name 1> + <name 2>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub love {
	my ($self,$client,$msg,$listener) = @_;	

	# Get the two names.
	my ($one,$two) = split(/\s+\+\s+/, $msg, 2);

	if (length $one > 0 && length $two > 0) {
		$first = uc($one);
		$first_len = length $one;
		$second = uc($two);
		$second_len = length $second;

		# Split the words.
		my @ch1 = split(//, $first);
		my @ch2 = split(//, $second);

		# The count.
		my $lovecount = 0;

		# A count to be used later.
		my $count;

		for ($count = 0; $count < $first_len; $count++) {
			my $letter1 = $ch1[$count];

			$lovecount += 2 if $letter1 eq 'L';
			$lovecount += 2 if $letter1 eq 'O';
			$lovecount += 2 if $letter1 eq 'V';
			$lovecount += 2 if $letter1 eq 'E';
			$lovecount += 3 if $letter1 eq 'Y';
			$lovecount += 1 if $letter1 eq 'O';
			$lovecount += 3 if $letter1 eq 'U';
		}
		for ($count = 0; $count < $second_len; $count++) {
			my $letter2 = $ch2[$count];

			$lovecount += 2 if $letter2 eq 'L';
			$lovecount += 2 if $letter2 eq 'O';
			$lovecount += 2 if $letter2 eq 'V';
			$lovecount += 2 if $letter2 eq 'E';
			$lovecount += 3 if $letter2 eq 'Y';
			$lovecount += 1 if $letter2 eq 'O';
			$lovecount += 3 if $letter2 eq 'U';
		}

		my $amount = 0;

		if ($lovecount > 0) {
			$amount = 5 - (($first_len + $second_len) / 2);
		}
		if ($lovecount > 2) {
			$amount = 10 - (($first_len + $second_len) / 2);
		}
		if ($lovecount > 4) {
			$amount = 20 - (($first_len + $second_len) / 2);
		}
		if ($lovecount > 6) {
			$amount = 30 - (($first_len + $second_len) / 2);
		}
		if ($lovecount > 8) {
			$amount = 40 - (($first_len + $second_len) / 2);
		}
		if ($lovecount > 10) {
			$amount = 50 - (($first_len + $second_len) / 2);
		}
		if ($lovecount > 12) {
			$amount = 60 - (($first_len + $second_len) / 2);
		}
		if ($lovecount > 14) {
			$amount = 70 - (($first_len + $second_len) / 2);
		}
		if ($lovecount > 16) {
			$amount = 80 - (($first_len + $second_len) / 2);
		}
		if ($lovecount > 18) {
			$amount = 90 - (($first_len + $second_len) / 2);
		}
		if ($lovecount > 20) {
			$amount = 100 - (($first_len + $second_len) / 2);
		}
		if ($lovecount > 22) {
			$amount = 110 - (($first_len + $second_len) / 2);
		}

		if ($first_len == 0 || $second_len == 0) {
			$amount = "Err";
		}
		$amount = 0 if $amount < 0;
		$amount = 99 if $amount > 99;

		my $result = $amount . '%';

		return "$one + $two = $result";
	}
	else {
		return "Proper format:\n\n"
			. "!love <lt>name 1<gt> + <lt>name 2<gt>\n\n"
			. "Example:\n"
			. "!love Dear Daniel + Hello Kitty";
	}
		
}

{
	Category => 'Fun & Games',
	Description => 'Love Calculator',
	Usage => '!love <name1> + <name2>',
	Listener => 'All',
};