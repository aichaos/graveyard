#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !reconnect
#    .::   ::.     Description // Shuts down and restarts the bot.
# ..:;;. ' .;;:..        Usage // !reconnect
#    .  '''  .     Permissions // Master Only
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub reconnect {
	my ($self,$client,$msg,$listener) = @_;

	# This is a Master-Only command.
	if (isMaster($client,$listener)) {
		# Sign off.
		my ($sn,$font,$color,$style);
		if ($listener eq "AIM") {
			$sn = $self->screenname();
			$sn = lc($sn);
			$sn =~ s/ //g;

			$font = get_font ($sn,"AIM");

			sleep(3);
			$self->send_im ($client,$font . "Rebooting . . .");
			sleep(1);
		}
		elsif ($listener eq "MSN") {
			$sn = $self->{Msn}->{Handle};
			$sn = lc($sn);
			$sn =~ s/ //g;

			($font,$color,$style) = get_font ($sn,"MSN");

			$self->sendtyping();
			sleep(1);
			$self->sendmsg ("Rebooting . . .",
				Font  => "$font",
				Color => "$color",
				Style => "$style",
			);
			sleep(1);
		}
		else {
			&panic ("Unknown messenger at commands/signoff.pl!", 0);
		}

		# And.... reboot.
		system ("start Juggernaut.bat");
		sleep(1);
		exit (0);
	}
	else {
		return "This command may only be used by the Master.";
	}
}

{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Signs Off & Restarts the Bot',
	Usage => '!reconnect',
	Listener => 'All',
};