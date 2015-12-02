# COMMAND NAME:
#	RELOAD
# DESCRIPTION:
#	Reload all the bot's files.
# COMPATIBILITY:
#	FULLY COMPATIBLE

sub reload {
	my ($self,$client,$msg,$listener) = @_;

	# Cut the command off..
	my $sym = get_comm_code();
	my $comm = ($sym . "reload");
	$msg =~ s/$comm //ig;
	$msg =~ s/$comm//ig;

	# Reload all the files!
	my @folders = (
		"commands/client",
		"commands/gifted",
		"commands/keeper",
		"commands/moderator",
		"commands/supermoderator",
		"commands/admin",
		"commands/superadmin",
		"commands/master",
		"handlers/aim",
		"handlers/http",
		"handlers/msn",
		"subroutines",
	);
	foreach $folder (@folders) {
		opendir (DIR, "./$folder");
		foreach $file (sort(grep(!/^\./, readdir(DIR)))) {
			# Reinclude this file.
			print "Reloading $folder/$file... ";
			do "./$folder/$file" or panic ("Failure to reload $folder/$file!", 0);
			print "\n";
		}
		closedir (DIR);
	}

	# Return the reply.
	$reply = "Files reloaded!";

	return $reply;
}
1;