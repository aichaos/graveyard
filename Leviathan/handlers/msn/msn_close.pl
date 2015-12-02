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
# MSN Handler: close
# Description: Called when a conversation is closed.

sub msn_close {
	my ($self) = @_;

	# Get this socket.
	my $sock = $self->getID;

	# Our handle.
	my $sn = $self->{Msn}->{Handle};
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Get the client.
	my $client = $chaos->{bots}->{$sn}->{sock_members}->{$sock};
	my @mem = split(/\,/, $client) if defined $client;

	print "Debug // \$client = $client\n"
		. "Debug // \@mem = @mem\n" if $chaos->{debug} == 1;

	my $stamp = &get_timestamp();
	print "$stamp\n"
		. "ChaosMSN: Now closing socket #$sock.\n"
		. "\t(Members: @mem)\n";

	#############################################
	# See if this socket was used for anything. #
	#############################################

	# See if this user participated in any games.
	print "Debug // Checking if this user was in any games...\n" if $chaos->{debug} == 1;
	foreach my $user (@mem) {
		$user = lc($user); $user =~ s/ //g;
		$user = 'MSN-' . $user;

		print "Debug // Checking user $user...\n" if $chaos->{debug} == 1;

		my @games = $chaos->{games}->findPlayer ($user);
		print "Debug // Games Array: @games\n" if $chaos->{debug} == 1;
		if (@games) {
			print "Debug // Array Is Defined! Checking each game...\n" if $chaos->{debug} == 1;
			foreach my $id (@games) {
				print "Debug // Checking game $id...\n" if $chaos->{debug} == 1;
				print "Debug // Valid ID!\n" if $chaos->{debug} == 1;
				next if $id eq '0';

				# Drop this player.
				$chaos->{games}->dropPlayer ($id, $user);

				# Broadcast to this game.
				$chaos->{games}->broadcast ($id, "$user has been disconnected (idle).");

				print "Debug // Dropped player from $id!\n" if $chaos->{debug} == 1;
			}
		}
	}

	# A "Shut Up!" socket.
	if (exists $chaos->{bots}->{$sn}->{_shutup}->{$sock}) {
		delete $chaos->{bots}->{$sn}->{_shutup}->{$sock};
		print "Socket #$sock was a \"Shut Up!\" socket - now deleted!\n";
	}

	print "\n";
	return 1;
}
{
	Type        => 'handler',
	Name        => 'msn_close',
	Description => 'Handles a conversation being closed.',
	Author      => 'Cerone Kirsle',
	Created     => '12:54 PM 11/21/2004',
	Updated     => '11:23 AM 1/22/2005',
	Version     => '1.1',
};