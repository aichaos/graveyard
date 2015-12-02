# queue.pl - Queue processors.

sub queue {
	my ($id,$wait,$code,$important) = @_;

	# If this ID exists, add to the queue.
	if (exists $aiden->{queue}->{$id}) {
		if ($important) {
			unshift (@{$aiden->{queue}->{$id}->{line}}, "$wait===$code");
		}
		else {
			push (@{$aiden->{queue}->{$id}->{line}}, "$wait===$code");
		}
	}
	else {
		# Create the queue for the first time.
		$aiden->{queue}->{$id}->{line} = [
			"$wait===$code",
		];
		$aiden->{queue}->{$id}->{waiting} = 0;
		$aiden->{queue}->{$id}->{waituntil} = 0;
	}
}
1;