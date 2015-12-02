# COMMAND NAME:
#	MSN
# DESCRIPTION:
#	Performs MSN commands.
# COMPATIBILITY:
#	MSN

sub msn {
	# Get variables from the shift.
	my ($client,$msg,$msn) = @_;

	# Cut !msn off the message.
	$msg =~ s/\!msn //g;

	# Split the command from the value
	my ($command,@value) = split(/ /, $msg);
	my $value = join(/ /, @value);

	# Go through the commands.
	if ($command eq "nick") {
		if (isAdmin($client) || isMod($client)) {
			$value =~ s/ /\%20/g;
			if ($value eq "default") {
				$msn->set_name ('Ultimate Chaos');
			}
			else {
				$msn->set_name ("$value");
			}
			$reply = "I have set my nick.";
		}
		else {
			$reply = "Sorry :-( this is a Mod-only command!";
		}
	}
	elsif ($command eq "im") {
		my ($who,$what) = split(/:/, $value);
		$msn->call ($who,$what);
		$reply = "I have sent the message.";
	}
	elsif ($command eq "invite") {
		$reply = "Calling $value...";
		$msn->invite ($value);
	}
	else {
		$reply = "The only command I support is !msn nick";
	}

	return $reply;
}
1;