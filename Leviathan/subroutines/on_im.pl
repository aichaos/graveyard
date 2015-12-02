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
#  Subroutine: on_im
# Description: Handles all messages.

sub on_im {
	# Get message data.
	my ($self,$sn,$client,$msg,$omsg) = @_;
	my $reply;

	########################################
	## Pre-IM Preparations and Filters    ##
	########################################

	# We are this sender's host.
	$chaos->{clients}->{$client}->{host} = $sn;

	# Separate this user's sender (messenger) and name.
	my ($sender,$nick) = split(/\-/, $client, 2);

	# Make sure they're not flooding.
	my ($isFlood,$floodReply) = &flood_check ($client,$msg);

	# Timestamps.
	my $time = &get_timestamp();

	# If flooding...
	if ($isFlood == 1) {
		# Return the reply.
		print "$time\n"
			. "ALERT: $client is flooding! Returning a flood reply...\n\n";
		return $floodReply;
	}

	# Remove trailing and leading spaces.
	$msg =~ s/^\s+//ig;
	$msg =~ s/\s+$//ig;

	# If this is MSN, get the socket number.
	my $sock = $self->getID if $sender eq 'MSN';

	# Maintenance mode?
	if ($chaos->{system}->{maintain}->{on} == 1) {
		# Only Admins can continue using the bot.
		if (!&isAdmin($client)) {
			return '<noreply>' if &isBlocked($client);

			# Return the maintenance message.
			print "$time\n"
				. "[$client] $msg\n"
				. "[$sn] $chaos->{system}->{maintain}->{msg}\n\n";
			return "<auto>$chaos->{system}->{maintain}->{msg}";
		}
	}

	# Special message cases.
	if ($msg =~ /aim remix/i) {
		# AIM Remix is an AIM flooder/crasher. Block the user with double punishment.
		&system_block ($client, 2);
		return '<noreply>';
	}
	if ($msg =~ /^(automessage|auto message|auto\-message)/i) {
		# Don't reply to automessages.
		return '<noreply>';
	}
	if ($msg =~ /^client\-name/i) {
		# Don't reply to ClientCaps.
		return '<noreply>';
	}
	if ($msg =~ /msnobj/i) {
		# Don't reply to MSN objects.
		return '<noreply>';
	}
	if ($msg eq 'Ping? [msgplus]') {
		# Pretend we're on MsgPlus.
		return '3Pong! [     ]';
	}

	########################################
	## Main Message Handler Code          ##
	########################################

	# Get this user's profile.
	&profile_get ($client);
	# If they don't have a name, set the default.
	if (!exists $chaos->{clients}->{$client}->{name}) {
		&profile_send ($client,'name',$client);
	}

	# (Re) format the bot's username.
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Save this user as our last client.
	$chaos->{bots}->{$sn}->{last_client} = $client;
	$chaos->{system}->{last_client} = $client;
	$chaos->{system}->{last_msg_on} = time();

	# See if this user is blocked or on the warners list.
	my $warner = &isWarner($client);
	my ($block,$level) = &isBlocked ($client);

	# Are they?
	if ($warner == 1 || $block == 1) {
		print "$time\n"
			. "CKS // Ignoring message from $client (blocked)\n"
			. "\tTheir Msg: $msg\n\n";

		# Send a SINGLE notification.
		if (!exists $chaos->{data}->{blockalerts}->{$client}) {
			$chaos->{data}->{blockalerts}->{$client} = 1;

			# A warner?
			if ($warner == 1) {
				# Warn them.
				$self->evil ($client,0) if $sender =~ /^(AIM|TOC)$/i;
				$level = "AIM Warner.";
			}
			$reply = "I'm sorry, but you are blocked and I cannot chat with you!\n\n"
				. "The block description is as follows:\n"
				. "$level";
			print "[$sn] $reply\n\n";
			return "<auto>$reply";
		}

		return '<blocked>';
	}

	# See if this is a command.
	my $isCommand = 0;
	($isCommand,$reply) = &isCommand ($self,$client,$msg);

	# If it's not a command, continue working with the message.
	if ($isCommand == 0) {
		# Do failsafe checks.
		if (exists $chaos->{clients}->{$client}->{failsafe}) {
			# Block him instantly.
			&system_block ($client,1);
		}

		# Don't get a reply if they want the bot to shut up.
		if (exists $chaos->{bots}->{$sn}->{_shutup}->{$sock} || $chaos->{clients}->{$client}->{mute} == 1) {
			# Ignore this.
		}
		else {
			# Perform substitutions in the message.
			$msg = &substitutions ($msg);

			# Make an uppercase copy of the message.
			my $umsg = uc($msg);

			# Log their last 10 messages (for repeat handlers).
			my ($i,$j);
			for ($i = 9; $i >= 1; $i--) {
				$j = $i + 1;
				$chaos->{clients}->{$client}->{_history}->{$j} = $chaos->{clients}->{$client}->{_history}->{$i};
				delete $chaos->{clients}->{$client}->{_history}->{$i};
			}
			$chaos->{clients}->{$client}->{_history}->{1} = $umsg;

			# Count any repeats.
			my $repeats = 0;
			for ($i = 1; $i <= 10; $i++) {
				last unless $chaos->{clients}->{$client}->{_history}->{2} eq $chaos->{clients}->{$client}->{_history}->{1};

				# A repeat?
				if ($chaos->{clients}->{$client}->{_history}->{$i} eq $chaos->{clients}->{$client}->{_history}->{1}) {
					$repeats++;
				}
			}

			# Repeat message handlers.
			if ($repeats >= 2 && $repeats < 7) {
				$msg = 'SYSTEM REPEAT SAFE';
				$umsg = $msg;
			}
			elsif ($repeats >= 7 && $repeats < 10) {
				$msg = 'SYSTEM REPEAT WARNING';
				$umsg = $msg;
			}
			elsif ($repeats >= 10) {
				$msg = 'SYSTEM REPEAT BAN';
				$umsg = $msg;
				print "*** Blocking $client for flooding! ***\n\n";
				&system_block ($client,1);
			}

			# Get the bot's brain.
			my $brain = $chaos->{bots}->{$sn}->{brain};
			$brain = lc($brain);
			$brain =~ s/ //g;
			my $get = $chaos->{system}->{brains}->{$brain}->{ReplySub};

			# Split up the message into sentences.
			my @splitters = $chaos->{config}->{sentence_splitters};
			foreach my $split (@splitters) {
				$msg =~ s/$split/<splitter>/ig;
			}
			my @msgs = split(/<splitter>/, $msg);

			# Send each message to the brain.
			my @response = ();
			foreach my $send (@msgs) {
				$send =~ s/^\s+//g;
				$send =~ s/\s+$//g;
				$send = &filter($send);

				next if length $send == 0;
				my $outgoing = &{$get} ($brain,$self,$client,$send,$omsg,$sn);
				push (@response, $outgoing);
			}
			$reply = join (" ", @response);
			if (length $reply == 0) {
				$reply = "Next time, try writing something productive!";
			}
		}
	}

	# Convert special codes.
	$reply =~ s/<lt>/&lt;/ig;
	$reply =~ s/<gt>/&gt;/ig;

	# Log this IM.
	&log_im ($client,$omsg,$sn,$reply);

	# If we support HTML, change \n to <br>.
	if ($sender =~ /^(AIM|TOC|HTTP)$/i) {
		$reply =~ s/\n/<br>/ig;
	}

	# Don't send comments.
	$reply =~ s/<\!\-\-(.*?)\-\->//ig;

	# Return the response.
	return $reply;
}
{
	Type        => 'subroutine',
	Name        => 'on_im',
	Usage       => '$reply = &on_im($self,$sn,$client,$msg,$omsg)',
	Description => 'Handles all messages.',
	Author      => 'Cerone Kirsle',
	Created     => '3:23 PM 11/20/2004',
	Updated     => '3:32 PM 3/7/2005',
	Version     => '1.0',
};