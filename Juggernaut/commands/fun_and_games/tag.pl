#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !tag
#    .::   ::.     Description // Simple game of IM Tag.
# ..:;;. ' .;;:..        Usage // !tag <username>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners (Single Sided)
#     :     :        Copyright // 2004 Chaos AI Technology

sub tag {
	my ($self,$client,$msg,$listener) = @_;

	# Get the screenname.
	my $screenname;
	$screenname = $self->screenname() if $listener eq "AIM";
	$screenname = $self->{Msn}->{Handle} if $listener eq "MSN";
	$screenname = lc($screenname) if $screenname;
	$screenname =~ s/ //g if $screenname;

	# Get a reference to the master object.
	my $master = $chaos->{$screenname}->{client} if $screenname;

	# Make sure we're on MSN or AIM..
	if ($listener eq "MSN" || $listener eq "AIM") {
		# If we have somebody TO tag, let's do it.
		if ($msg) {
			my $tagmsg;
			if ($listener eq "AIM") {
				$msg = lc($msg);
				$msg =~ s/ //g;

				# Make sure the user is active.
				if (!exists $chaos->{_users}->{$msg}->{_active} || time - $chaos->{_users}->{$msg}->{_active} > 60) {
					return "That username has not sent me a message in the last 60 "
						. "seconds. It's a security precaution that I never am "
						. "the one to initiate a new conversation. Get your friend "
						. "to send me a message, and then you can send them a "
						. "message through me. :-)";
				}

				$tagmsg = "<body bgcolor=\"white\">"
					. "<font face=\"Verdana\" size=\"2\" color=\"black\">"
					. "You have been <b>Tagged</b> by $client! We're playing "
					. "IM Tag. To tag somebody, type !tag screenname</font></body>";
				&dosleep(3);
				$master->send_im ($msg,$tagmsg);
			}
			elsif ($listener eq "MSN") {
				if ($msg =~ /\@/ && $msg =~ /\./) {
					$tagmsg = "You have been TAGGED by (M) $client! We're playing IM Tag. "
						. "To tag somebody, type !tag email";
					print "Tagging $msg...\n";
					$master->call ($msg,$tagmsg);
				}
				else {
					return "You must use a proper MSN passport e-mail address for this command.";
				}
			}

			return "I have attempted to tag $msg.";
		}
		else {
			return "You must give me a username to tag, i.e.\n\n"
				. "!tag username\n\n"
				. "The username you tag has to be on the same messenger as "
				. "you are (if you are on AIM, you can only tag AIM or AOL "
				. "users; MSN can tag only MSN users)";
		}
	}
	else {
		return "Sorry, this command is for AIM and MSN only.";
	}

	return "Unknown error at TAG.pl";
}

{
	Category => 'Fun & Games',
	Description => 'IM Tag',
	Usage => '!tag <username>',
	Listener => 'All',
};