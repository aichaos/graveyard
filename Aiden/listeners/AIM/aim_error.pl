# Error handlers.

sub aim_error {
	my ($aim,$conn,$error,$desc,$fatal) = @_;

	my $sn = $aim->screenname();
	print &timestamp . "\n"
		. "AidenAIM: AIM Error\n"
		. "\tScreenName: $sn\n"
		. "\tError $error: $desc\n"
		. "\tFatal: $fatal\n\n";
}
1;