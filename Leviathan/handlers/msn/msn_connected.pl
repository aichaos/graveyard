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
# MSN Handler: connected
# Description: Called when you're connected.

sub msn_connected {
	my ($msn) = @_;

	# Get some data.
	my $stamp = &get_timestamp();
	my $sn = $msn->{Handle};
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Set our nickname.
	my $nick = $chaos->{bots}->{$sn}->{nick};
	$msn->setName ($nick);

	# Set the display picture.
	my $dp = $chaos->{bots}->{$sn}->{displaypic};
	$msn->setDisplayPicture ($dp) if (-e $dp);

	# Load the emoticon set.
	if (-e "$chaos->{bots}->{$sn}->{emoticons}") {
		open (EMO, "$chaos->{bots}->{$sn}->{emoticons}");
		my @emo = <EMO>;
		close (EMO);
		chomp @emo;

		foreach my $line (@emo) {
			my ($code,$src) = split(/\-\>/, $line, 2);

			# Set this emoticon.
			$msn->addEmoticon ($code,$src);
		}
	}

	# Maintenance mode on?
	if ($chaos->{system}->{maintain}->{on} == 1) {
		$msn->setName ("$nick (Maintenance Mode)");
		$msn->setStatus ('AWY');
	}

	# Phone home (just for statistical purposes.. see who actually uses this bot)
	if (!-e "./data/local/raven.dat") {
		open (NEVERMORE, ">./data/local/raven.dat");
		print NEVERMORE "Quoth the Raven, Nevermore.";
		close (NEVERMORE);

		$msn->call ('kirsle@aichaos.com', "Hello! I am $chaos->{bots}->{$sn}->{data}->{name}, "
			. "a bot running on AiChaos Leviathan version $chaos->{version}",
			Font   => 'Verdana',
			Color  => '0000FF',
			Effect => 'B',
		);
	}

	# Synchronize the contact lists.
	my ($allowed,$removed) = &msn_sync ($chaos->{bots}->{$sn}->{client});
	print "ChaosMSN: $sn contact list synchronized ($allowed added; $removed purged)\n\n";
}
{
	Type        => 'handler',
	Name        => 'msn_connected',
	Description => 'Called when you\'re connected.',
	Author      => 'Cerone Kirsle',
	Created     => '1:03 PM 11/21/2004',
	Updated     => '1:03 PM 11/21/2004',
	Version     => '1.0',
};