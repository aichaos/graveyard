# COMMAND NAME:
#	RELOAD
# DESCRIPTION:
#	Reload all of the bot's files.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub reload {
	# Get variables from the shift.
	my ($client,$msg,$self) = @_;

	if (isAdmin($client)) {
		my @dirs = (
			"handlers/aim",
			"handlers/msn",
			"commands",
			"subroutines",
		);
		foreach $folder (@dirs) {
			print "Working in folder $folder.\n";
			opendir (DIR, "./$folder");
			foreach $file (sort(grep(!/^\./, readdir(DIR)))) {
				print "\tReloading $dir\/$file... ";
				do "./$dir/$file";
				print "Done!\n";
			}
			closedir (DIR);
		}
		$reply = "Files reloaded!";
	}
	else {
		$reply = "Sorry, this is an admin-only command!";
	}

	return $reply;
}
1;