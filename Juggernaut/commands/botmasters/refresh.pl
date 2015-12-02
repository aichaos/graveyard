#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !refresh
#    .::   ::.     Description // Reverts bot back to original config settings.
# ..:;;. ' .;;:..        Usage // !refresh
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub refresh {
	my ($self,$client,$msg,$listener) = @_;

	# Only the Master can use this command.
	if (isMaster($client,$listener)) {
		# Get our current name.
		my $sn;
		if ($listener eq "AIM") {
			$sn = $self->screenname();
		}
		elsif ($listener eq "MSN") {
			$sn = $self->{Msn}->{Handle};
		}
		else {
			return "Unknown listener.";
		}
		$sn = lc($sn);
		$sn =~ s/ //g;

		# If we're on AIM, this means reloading our profile and s/n formatting.
		if ($listener eq "AIM") {
			# Format the screenname.
			my $format = $chaos->{$sn}->{format};
			$self->format_screenname ($format);

			# Load the profile.
			my $profile = $chaos->{$sn}->{profile};
			open (PRO, "$profile");
			my @profile = <PRO>;
			close (PRO);
			chomp @profile;

			my $prodata;
			foreach my $line (@profile) {
				$prodata .= "$line";
			}

			# Set our profile.
			$self->set_info ($prodata);

			# Save changes.
			$self->commit_buddylist();

			return "ChaosAIM // $sn\n\n"
				. "Bot has been restored to original settings:\n"
				. "o AIM Profile Information Reset\n"
				. "o ScreenName Format Restored";
		}
		elsif ($listener eq "MSN") {
			# If we're on MSN, this means re-setting our display name and picture.
			my $nick = $chaos->{$sn}->{nick};
			$self->set_name ($nick);

			# Display Picture.
			my $dp = $chaos->{$sn}->{displaypic};
			$chaos->{$sn}->{client}->display_picture ($dp);

			return "ChaosMSN // $sn\n\n"
				. "Bot has been restored to original settings:\n"
				. "o MSN Display Name Reset\n"
				. "o MSN Display Picture Reset";
		}
		else {
			return "Strangely the listener was not matched after the second check.";
		}
	}
	else {
		return "This command may only be used by the Master.";
	}
}

{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Restores Bots\' Original Settings',
	Usage => '!refresh',
	Listener => 'All',
};