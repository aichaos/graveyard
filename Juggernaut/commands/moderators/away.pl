#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !away
#    .::   ::.     Description // Set an away message or status.
# ..:;;. ' .;;:..        Usage // !away [message or status]
#    .  '''  .     Permissions // Moderator
#     :;,:,;:         Listener // AIM, MSN
#     :     :        Copyright // 2004 Chaos AI Technology

sub away {
	my ($self,$client,$msg,$listener) = @_;

	# Filter things.
	$msg =~ s/\&amp\;/\&/ig;
	$msg =~ s/\&lt\;/</ig;
	$msg =~ s/\&gt\;/>/ig;
	$msg =~ s/\&quot\;/"/ig;
	$msg =~ s/\&apos\;/'/ig;

	# This command is Moderator Only.
	if (isMod($client,$listener)) {
		# Set your away status.
		my $sn;
		if ($listener eq "AIM") {
			if (length $msg == 0) {
				$msg = "I am away from my computer.";
			}

			$sn = $self->screenname();
			my $font = get_font ($sn,"AIM");
			my $awaymsg = $font . $msg;
			$self->set_away ($awaymsg);

			# Return reply.
			return "I have set the away message.";
		}
		elsif ($listener eq "MSN") {
			# English status messages...
			$msg = 'BSY' if $msg =~ /busy/i;
			$msg = 'IDL' if $msg =~ /idle/i;
			$msg = 'BRB' if $msg =~ /be right back/i;
			$msg = 'PHN' if $msg =~ /phone/i;
			$msg = 'LUN' if $msg =~ /lunch/i;

			$msg = uc($msg);

			$sn = $self->{Msn}->{Handle};
			$sn = lc($sn);
			$sn =~ s/ //g;

			my $msn = $chaos->{$sn}->{client};

			if ($msg =~ /^(BSY|IDL|BRB|PHN|LUN)$/) {
				# Set away status.
				$msn->setStatus ("$msg");
			}
			else {
				$msn->setStatus ('AWY');
			}

			return "I have set my away status.";
		}
		else {
			return "This command applies only to AIM and MSN.";
		}
	}
	else {
		return "This command is Moderator Only.";
	}
}

{
	Restrict => 'Moderator',
	Category => 'Moderator Commands',
	Description => 'Set an Away Status',
	Usage => '!away [msg|status]',
	Listener => 'AIM/MSN',
};