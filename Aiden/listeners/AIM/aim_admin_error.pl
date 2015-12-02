# Admin Errors.

sub aim_admin_error {
	my ($aim,$type,$error,$url) = @_;

	print &timestamp . "\n"
		. "AidenAIM: Admin Error\n"
		. "\tType: $type\n"
		. "\tError: $error\n"
		. "\tURL: $url\n\n";
}
1;