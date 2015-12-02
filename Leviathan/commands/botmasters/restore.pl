#      .   .               <Leviathan>
#     .:...::     Command Name // !restore
#    .::   ::.     Description // Restores the bot to its original settings.
# ..:;;. ' .;;:..        Usage // !restore
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // AIM,MSN
#     :     :        Copyright // 2005 AiChaos Inc.

sub restore {
	my ($self,$client,$msg) = @_;

	my ($listener,$nick) = split(/\-/, $client, 2);

	# Some globals for use later.
	my $sn;
	$sn = $self->{Msn}->{Handle} if $listener eq "MSN";
	$sn = $self->screenname() if $listener eq "AIM";
	$sn = $self->nick() if $listener eq "IRC";
	$sn = $self->{username} if $listener eq "JABBER";
	$sn = '_http' if $listener eq "HTTP";
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Master only.
	if (&isMaster($client)) {
		return "This only applies to AIM and MSN." unless $listener =~ /^(aim|msn)$/i;

		# AIM...
		if ($listener eq "AIM") {
			# Tasks to complete.
			my %tasks = (
				'Format Screenname' => 'Failed',
				'Upload BuddyIcon'  => 'Failed',
				'Set Profile'       => 'Failed',
			);

			# Format screenname.
			my $format = $chaos->{bots}->{$sn}->{format};
			$self->format_screenname ($format);
			$tasks{'Format Screenname'} = 'Success';

			# Set buddy icon.
			if (-s $cks->{bots}->{$sn}->{icon} < 4000) {
				my $size = (-s $cks->{bots}->{$sn}->{icon}) / 1000;

				# Load the icon.
				open (ICON, $cks->{bots}->{$sn}->{icon});
				binmode ICON;
				my @icon = <ICON>;
				close (ICON);

				# Set the icon.
				my $asc = CORE::join ("",@icon);
				$self->set_icon ($asc);
				$tasks{'Upload BuddyIcon'} = 'Success';
			}

			# Load the profile.
			my $profile = $chaos->{bots}->{$sn}->{profile};
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
			$tasks{'Set Profile'} = 'Success';

			# Save changes.
			$self->commit_buddylist();

			return "AIM Bot Restored Successfully!\n\n"
				. "o Format Screenname: $tasks{'Format Screenname'}\n"
				. "o Upload BuddyIcon: $tasks{'Upload BuddyIcon'}\n"
				. "o Set Profile: $tasks{'Set Profile'}";
		}
		elsif ($listener eq "MSN") {
			# If we're on MSN, this means re-setting our display name and picture.
			my $nick = $chaos->{bots}->{$sn}->{nick};
			$chaos->{bots}->{$sn}->{client}->set_name ($nick);

			# Display Picture.
			my $dp = $chaos->{bots}->{$sn}->{displaypic};
			$chaos->{bots}->{$sn}->{client}->display_picture ($dp);

			return "MSN Bot Restored Successfully!\n\n"
				. "o MSN Display Name Reset\n"
				. "o MSN Display Picture Reset";
		}
		else {
			return "Unknown error!";
		}
	}
	else {
		return "This command can only be used by Botmasters.";
	}
}

{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Restores the bot to original settings.',
	Usage => '!restore',
	Listener => 'All',
};