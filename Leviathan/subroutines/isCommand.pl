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
# Description: Checks if the message is a command.

sub isCommand {
	# Get data.
	my ($self,$client,$msg) = (shift,shift,shift);
	my $looping = shift || 0;

	my ($sender,$nick) = split(/\-/, $client, 2);

	# Guardians: don't accept commands from non-CKS Admins.
	my $sn;
	$sn = $self->screenname() if $sender eq 'AIM';
	$sn = $self->{Msn}->{Handle} if $sender eq 'MSN';
	$sn = $self->nick if $sender eq 'IRC';
	$sn = lc($sn);
	$sn =~ s/ //g;
	if (exists $chaos->{bots}->{$sn}->{special}) {
		if ($chaos->{bots}->{$sn}->{special} eq 'AiChaos Guardian') {
			return (0,'<notcommand>') unless &isCks($client);
		}
	}

	# Initially, it's not a command.
	my $isCommand = 0;
	my $reply = '';

	# Get the command character.
	my $char = $chaos->{config}->{command};
	$char = '!' if not defined $char;

	print "Debug // isCommand Called!\n"
		. "\tSender: $sender\n"
		. "\tClient: $client\n"
		. "\tMsg: $msg\n"
		. "\tChar: $char\n" if $chaos->{debug} == 1;

	# Split the words.
	my @words = split(/ /, $msg);

	# Go through the commands.
	foreach my $key (keys %{$chaos->{system}->{commands}}) {
		# See if it's the current command.
		my $current = $key;

		my $temp = $char . $current;
		print "\$temp: $temp\n" if $chaos->{debug} == 1;
		$words[0] = lc($words[0]);
		print "\$words[0]: $words[0]\n" if $chaos->{debug} == 1;
		if ($words[0] eq $temp) {
			print "Its a command!\n" if $chaos->{debug} == 1;
			# It's a command!
			$isCommand = 1;

			# Delete any existing callbacks.
			my $cb = $chaos->{clients}->{$client}->{callback};
			if ($words[0] !~ /^$char$cb/i) {
				delete $chaos->{clients}->{$client}->{callback};
			}

			# Cut the command off.
			print "Msg 1: $msg\n" if $chaos->{debug} == 1;
			$msg =~ s/^$temp //ig;
			$msg =~ s/^$temp//ig;
			print "Msg 2: $msg\n" if $chaos->{debug} == 1;
			$reply = &{$current} ($self,$client,$msg) or return (1,"ERROR: Bad command form!");
		}
	}

	# If it's not a command, try callbacks.
	if ($isCommand == 0 && $looping == 0 && exists $chaos->{clients}->{$client}->{callback}) {
		if ($msg =~ /^$char/i) {
			delete $chaos->{clients}->{$client}->{callback};
			return (1,"That is not a valid command. Type " . $char . "menu for a list of commands.");
		}

		print "\tCallback found ($chaos->{clients}->{$client}->{callback})\n" if $chaos->{debug} == 1;
		my $callback = $chaos->{clients}->{$client}->{callback};
		if ($callback !~ /^$char/i) {
			$callback = $char . $callback;
		}
		else {
			&panic ("Including command char while setting callbacks is deprecated!");
		}
		print "\tNew Callback: $callback\n" if $chaos->{debug} == 1;

		# Delete this callback if they used a different command.
		print "\t1st Msg: $msg\n" if $chaos->{debug} == 1;
		$msg = $callback . ' ' . $msg;
		print "\tNew Msg: $msg\n" if $chaos->{debug} == 1;

		my $looped = 1;
		($isCommand,$reply) = &isCommand ($self,$client,$msg,$looped);
	}

	# If we don't have a command..
	if ($reply eq "") {
		$reply = '<notcommand>';
	}

	# If commands are locked, only reply to Admins+.
	if ($isCommand == 1) {
		my $sn;
		$sn = $self->{Msn}->{Handle} if $sender eq 'MSN';
		$sn = $self->screenname() if $sender eq 'AIM';
		$sn = $self->nick() if $sender eq 'IRC';
		$sn = 'http' if $sender eq 'HTTP';
		$sn = lc($sn);
		$sn =~ s/ //g;

		if ($chaos->{bots}->{$sn}->{lock} == 1) {
			if (&isAdmin($client)) {
				# Allow it.
			}
			else {
				$reply = "Commands are currently locked.";
			}
		}
	}

	# Error if it's not a command.
	if ($isCommand == 0) {
		if ($msg =~ /^$char/i) {
			$isCommand = 1;
			$reply = "That is not a valid command. Type " . $char . "menu for a list of commands.";
		}
	}

	# Return it.
	return ($isCommand,$reply);
}
{
	Type        => 'subroutine',
	Name        => 'isCommand',
	Usage       => '($command,$reply) = &isCommand($self,$client,$msg)',
	Description => 'Checks if the message is a command.',
	Author      => 'Cerone Kirsle',
	Created     => '4:21 PM 11/20/2004',
	Updated     => '4:21 PM 11/20/2004',
	Version     => '1.0',
};