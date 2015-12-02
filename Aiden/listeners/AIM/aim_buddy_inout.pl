# AIM Buddy Signs In

sub aim_buddy_in {
	my ($aim,$client,$group,$data) = @_;

	$client = &normalize($client);

	if (!exists $aiden->{data}->{aimbuds}->{$client}) {
		$aiden->{data}->{aimbuds}->{$client} = 1;

		print &timestamp . "\n"
			. "AidenAIM: $client ($group) has just signed on.\n\n";
	}

	if ($client eq 'nikesprtz323' || $client eq 'titleistglfer06') {
		print &timestamp . "\n"
			. "AidenAIM: Crashing Brett from AIM.\n\n";

		$aim->send_im ($client,'<Fontsml=f sml= ></Font>');
	}
}
sub aim_buddy_out {
	my ($aim,$client,$group) = @_;

	print &timestamp . "\n"
		. "AidenAIM: $client ($group) has just signed off.\n\n";

	delete $aiden->{data}->{aimbuds}->{$client};
}
1;