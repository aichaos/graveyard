#              ::.                   .:.
#               .;;:  ..:::::::.  .,;:
#                 ii;,,::.....::,;;i:
#               .,;ii:          :ii;;:
#             .;, ,iii.         iii: .;,
#            ,;   ;iii.         iii;   :;.
# .         ,,   ,iii,          ;iii;   ,;
#  ::       i  :;iii;     ;.    .;iii;.  ,,      .:;
#   .,;,,,,;iiiiii;:     ,ii:     :;iiii;;i:::,,;:
#     .:,;iii;;;,.      ;iiii:      :,;iiiiii;,:
#          :;        .:,,:..:,,.        .:;..
#           i.                  .        ,:
#           :;.         ..:...          ,;
#            ,;.    .,;iiiiiiii;:.     ,,
#             .;,  :iiiii;;;;iiiii,  :;:
#                ,iii,:        .,ii;;.
#                ,ii,,,,:::::::,,,;i;
#                ;;.   ...:.:..    ;i
#                ;:                :;
#                .:                ..
#                 ,                :
#  Subroutine: isCommand
# Description: Sees if the message is a command or not.

sub isCommand {
	# Get variables from the shift.
	my ($self,$client,$msg,$listener) = @_;

	# Don't allow changing a command while super callbacks are in play.
	if (exists $chaos->{_users}->{$client}->{scallback}) {
		return (0,'');
	}

	# Initially, it's not a command.
	my $command = 0;
	my $reply;

	# Find out our command char from the config hash.
	my $char = $chaos->{_system}->{config}->{commandchar};
	$char = '!' if not defined $char;

	# Split the words apart.
	my @words = split(/\s+/, $msg);

	# Go through the commands hash.
	foreach my $key (keys %{$chaos->{_system}->{commands}}) {
		# See if this is a command.
		my $current = $key;

		my $temp = $char . $current;
		$words[0] = lc($words[0]);
		if ($words[0] eq "$temp") {
			# It's a command.
			$command = 1;

			# If they have a callback already, delete it.
			if (exists $chaos->{_users}->{$client}->{callback}) {
				delete $chaos->{_users}->{$client}->{callback};
			}

			# Cut the command off.
			$msg =~ s/$temp //ig;
			$msg =~ s/$temp//ig;
			$reply = &{$current} ($self,$client,$msg,$listener) || panic ("Bad command form: no reply", 1);
		}
	}

	# If we don't have a command...
	if ($reply eq "") {
		$reply = "<notcommand>";
	}

	# If the commands are locked, only allow response to Admins.
	if ($command == 1) {
		my $sn;
		$sn = $self->GetMaster->{Handle} if $listener eq "MSN";
		$sn = $self->screenname() if $listener eq "AIM";
		$sn = lc($sn);
		$sn =~ s/ //g;

		if ($chaos->{$sn}->{lock} == 1) {
			print "Debug // Commands Locked\n";
			if (isAdmin($client,$listener)) {
				print "Debug // Is Admin\n";
				# Allow it.
			}
			else {
				print "Debug // Isnt Admin\n";
				$reply = "Commands are currently locked.";
			}
		}
	}

	# Error if it's not a command.
	if ($command == 0) {
		if ($msg =~ /^$char/i) {
			$command = 1;
			$reply = "That is not a valid command. Type " . $char . "menu for a list of commands.";
		}
	}

	# Return the reply.
	return ($command,$reply);
}
1;