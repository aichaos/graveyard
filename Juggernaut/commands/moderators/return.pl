#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !return
#    .::   ::.     Description // Return from away status.
# ..:;;. ' .;;:..        Usage // !return
#    .  '''  .     Permissions // Moderator Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub return {
	my ($self,$client,$msg,$listener) = @_;

	# This command is moderator only.
	if (isMod($client,$listener)) {
		# Come back from away.
		if ($listener eq "AIM") {
			$self->set_away ("");

			# Return reply.
			return "I have returned from away status.";
		}
		elsif ($listener eq "MSN") {
			my $handle = $self->{Msn}->{Handle};
			$handle = lc($handle);
			$handle =~ s/ //g;

			my $msn = $chaos->{$handle}->{client};

			$msn->setStatus ('NLN');

			return "I have returned from away status.";
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
	Description => 'Return From Away Status',
	Usage => '!return',
	Listener => 'AIM/MSN',
};