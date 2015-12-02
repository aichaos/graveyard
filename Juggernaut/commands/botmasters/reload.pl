#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !reload
#    .::   ::.     Description // Reload the bot's files and replies.
# ..:;;. ' .;;:..        Usage // !reload
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub reload {
	my ($self,$client,$msg,$listener) = @_;

	my $sn;
	$sn = $self->{Msn}->{Handle} if $listener eq "MSN";
	$sn = $self->screenname() if $listener eq "AIM";
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Make sure they're master.
	if (isMaster($client,$listener)) {
		# Array of bad files.
		my @errors;

		# Reload all the files!
		my @folders = (
			"brains",
			"handlers/aim",
			"handlers/http",
			"handlers/msn",
			"subroutines",
			"settings",
		);
		foreach $folder (@folders) {
			opendir (DIR, "./$folder");
			foreach $file (sort(grep(!/^\./, readdir(DIR)))) {
				# Reinclude this file.
				print "Reloading $folder/$file... ";
				do "./$folder/$file" or push (@errors, "./$folder/$file");
				print "\n";
			}
			closedir (DIR);
		}

		# Also reload commands and replies.
		&load_commands();
		&load_replies($sn,$chaos->{$sn}->{brain},$chaos->{$sn}->{reply});

		# If there were errors...
		if (length $errors[0] > 0) {
			my $all_errors = join ("\n", @errors);
			return "Bot was not reloaded successfully. Erraneous files:\n\n"
				. $all_errors;
		}
		else {
			return "Bot reloaded successfully! :-D";
		}
	}
	else {
		$reply = "Only Masters can use this command.";
	}

	return $reply;
}

{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Reloads All Bot Files',
	Usage => '!reload',
	Listener => 'All',
};