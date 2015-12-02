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
# MSN Handler: answer
# Description: Called when a conversation is created.

sub msn_answer {
	my ($self) = @_;

	# Get time and handle.
	my $stamp = &get_timestamp();
	my $sn = $self->{Msn}->{Handle};
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Get the user(s) name.
	my $sock = $self->getID;
	my $buddies = $self->getMembers ($sock);
	my $client = join (",", keys %{$buddies});
	$client = '<unknown>' unless defined $client;
	$chaos->{bots}->{$sn}->{sock_members}->{$sock} = $client;

	&panic ("Unknown username in MSN_ANSWER",0) if $client eq '<unknown>';

	# Get the font.
	my ($font,$color,$style) = &get_font ($sn,'MSN');

	print "$stamp\n"
		. "ChaosMSN: $client has created a new socket (\#$sock)!\n\n";

	my @users = split(/\,/, $client);

	# Too many users?
	if (scalar(@users) > 1) {
		if ($chaos->{config}->{msn}->{allow_chat} == 0) {
			# If there are more than or equal to 3 participants: block ALLL of them, if they don't fucking
			# learn after the bot ignores their Rings for a good 15 minutes, it will just have to block them
			# AGAIN!!!!!!!
			if (scalar(@users) >= 3) {
				# Block their asses.
				foreach my $moron (@users) {
					print "ChaosMSN: Blocking all the morons involved, they should learn.\n\n";
					$moron = 'MSN-' . $moron;
					&system_block ($moron, 1);
				}
			}

			# Leave immediately. Don't even say anything.
			print "ChaosMSN: Leaving socket #$sock -- too many members!\n\n";
			&queue ($sn, 0, "my \$convo = \$chaos->{bots}->{'$sn'}->{client}->getConvo ($sock); "
				. "\$convo->leave();");
			return 1;
		}
	}

	# If they're blocked...
	my ($isBlocked,$blockee,$blockeeLevel) = (0,'','');
	foreach my $usr (@users) {
		$usr = 'MSN-' . $usr;
		my ($blocked,$blockLevel) = &isBlocked ($usr);

		if ($blocked eq '1') {
			$isBlocked = 1;
			$blockee = $usr;
			$blockee =~ s/^MSN\-//i;
			$blockeeLevel = $blockLevel;
			last;
		}
	}
	if ($isBlocked == 1) {
		my $blockreply;
		if (scalar(@users) > 1) {
			$blockreply = "One of you is blocked from chatting with me, and I will not "
				. "remain in this conversation. The block description is as follows:\n\n"
				. "Username: $blockee\n"
				. "$blockeeLevel";
			$self->sendMessage ($blockreply,
				Font   => $font,
				Color  => $color,
				Effect => $style,
			);
			print "$stamp\n"
				. "ChaosMSN: [$sn] $blockreply\n\n";

			$chaos->{bots}->{$sn}->{_shutup}->{$sock} = 1;
			sleep(1);
			&queue ($sn, 3, "my \$convo = \$chaos->{bots}->{'$sn'}->{client}->getConvo ($sock); "
				. "\$convo->leave();");
			return 1;
		}
		else {
			$blockreply = "Hello, $blockee. I am informing you that you are currently blocked "
				. "from chatting with me. The description is as follows:\n\n"
				. "$blockeeLevel";
			$self->sendMessage ($blockreply,
				Font   => $font,
				Color  => $color,
				Effect => $style,
			);
			print "$stamp\n"
				. "ChaosMSN: [$sn] $blockreply\n\n";
		}

		return 1;
	}
}
{
	Type        => 'handler',
	Name        => 'msn_answer',
	Description => 'Handles a conversation being created.',
	Author      => 'Cerone Kirsle',
	Created     => '9:39 AM 11/21/2004',
	Updated     => '1:21 PM 4/3/2005',
	Version     => '1.2',
};