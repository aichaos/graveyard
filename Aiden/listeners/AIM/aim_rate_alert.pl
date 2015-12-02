# Error handlers.

sub aim_rate_alert {
	my ($aim,$level,$clear,$window,$worry) = @_;

	my $sn = $aim->screenname();
	print &timestamp . "\n"
		. "AidenAIM: $sn Rate Alert Error\n\n";
}
1;