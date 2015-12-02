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
#  Subroutine: gamesend
# Description: Broadcast messages to game players.

sub gamesend {
	my %data = @_;

	# Get data.
	my $to  = $data{to};
	my $msg = $data{message};

	# Get this host.
	my $host = $chaos->{clients}->{$to}->{host};

	# More data about the client.
	my ($listener,$nick) = split(/\-/, $to, 2);

	# Queue the messages!
	if ($listener eq 'AIM') {
		$msg =~ s/\n/<br>/g;
		$msg =~ s/<lt>/&lt;/g;
		$msg =~ s/<gt>/&gt;/g;
		my $send = '<body bgcolor="#FFFFFF" link="#0000FF" vlink="#FF0000"><font face="Verdana" size="2" color="#000000">'
			. $msg . '</font></body>';
		$send =~ s/\'/\\'/g;
		$nick =~ s/\'/\\'/g;
		&queue ($host, 3, "\$chaos->{bots}->{'$host'}->{client}->send_im ('$nick', '$send');");
	}
	elsif ($listener eq 'MSN') {
		$msg =~ s/<lt>/</g;
		$msg =~ s/<gt>/>/g;
		my $send = $msg;
		$send =~ s/\'/\\'/g;
		$nick =~ s/\'/\\'/g;
		&queue ($host, 1, "\$chaos->{bots}->{'$host'}->{client}->call ('$nick', '$send', Font => 'Verdana', Color => '000000', Effect => '');");
	}
	elsif ($listener eq 'YAHOO') {
		$msg =~ s/<lt>/&lt;/g;
		$msg =~ s/<gt>/&gt;/g;
		my $send = '<font face="Verdana">' . $msg;
		$send =~ s/\'/\\'/g;
		$nick =~ s/\'/\\'/g;
		&queue ($host, 1, "\$chaos->{bots}->{'$host'}->{client}->sendMessage ('$nick', '$send');");
	}
	elsif ($listener eq 'JABBER') {
		$msg =~ s/<lt>/</g;
		$msg =~ s/<gt>/>/g;
		my $send = $msg;
		$send =~ s/\'/\\'/g;
		$nick =~ s/\'/\\'/g;
		&queue ($host, 0, "\$chaos->{bots}->{'$host'}->{client}->MessageSend ("
			. "to => '$username',"
			. "type => 'chat',"
			. "body => '$send' );");
	}
	elsif ($listener eq 'IRC') {
		$msg =~ s/<lt>/</g;
		$msg =~ s/<gt>/>/g;
		my $send = $msg;
		$send =~ s/\'/\\'/g;
		$nick =~ s/\'/\\'/g;
		&queue ($host, 0, "\$chaos->{bots}->{'$host'}->{client}->privmsg ('$nick','$send');");
	}
	else {
		# Not yet supported.
	}

				# Add this to the queue.
				&queue ($sn,0,"\$chaos->{bots}->{'$sn'}->{client}->MessageSend ("
					. "to => '$username',"
					. "type => 'chat',"
					. "body => '$send' );");

	return 1;
}
{
	Type        => 'subroutine',
	Name        => 'gamesend',
	Usage       => '&gamesend(data)',
	Description => 'Broadcast messages to game players.',
	Author      => 'Cerone Kirsle',
	Created     => '4:08 PM 1/18/2005',
	Updated     => '4:09 PM 1/18/2005',
	Version     => '1.0',
};