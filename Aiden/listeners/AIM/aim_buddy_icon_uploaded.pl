# Buddy icon has been uploaded.

sub aim_buddy_icon_uploaded {
	my ($aim) = @_;

	my $sn = &normalize($aim->screenname);

	print &timestamp . "\n"
		. "AidenAIM: $sn buddy icon uploaded successfully!\n\n";
}
1;