# COMMAND NAME:
#	ALERT
# DESCRIPTION:
#	Pops up an MSN Alert Message.
# COMPATIBILITY:
#	MSN

sub alert {
	my ($self,$client,$msg,$listener) = @_;

	# Make sure we're on MSN.
	if ($listener eq "MSN") {
		# Make sure there's an alert message.
		if ($msg) {
			# Get their permission level.
			&profile_get ($client,$listener);

			# Get the client count.
			my $client_count = 0;
			opendir (DIR, "./clients");
			foreach $file (sort(grep(!/^\./, readdir(DIR)))) {
				$client_count++;
			}
			closedir (DIR);

			# Insert special variables.
			$msg =~ s/\[clients\]/$client_count/ig;
			$msg =~ s/\[client\]/$client_count/ig;
			$msg =~ s/\[count\]/$client_count/ig;

			# Get the default name.
			my $default = get_msn_nick ($self->GetMaster->{Handle});

			# Pop up the alert.
			$self->set_status ('HDN');
			$self->set_name ("$chaos->{users}->{$client}->{permission} Alert: $msg");
			$self->set_status ('NLN');
			$self->set_name ("$default");

			# Reply.
			$reply = "I have set the alert.";
		}
		else {
			$reply = ("Improper usage. Correct usage is\n\n"
				. "!alert [message]");
		}
	}
	else {
		$reply = "This command is for MSN Messenger only!";
	}

	return $reply;
}
1;