#      .   .               <Leviathan>
#     .:...::     Command Name // !shout
#    .::   ::.     Description // Broadcast a message to all sockets.
# ..:;;. ' .;;:..        Usage // !shout <message>[::color]
#    .  '''  .     Permissions // Administrator Only.
#     :;,:,;:         Listener // MSN
#     :     :        Copyright // 2005 AiChaos Inc.

sub shout {
	my ($self,$client,$msg) = @_;

	# Must be an admin.
	return "This command may only be used by Administrators and higher!" unless &isAdmin($client);

	# Get the messenger.
	my ($sender,$nick) = split(/\-/, $client, 2);

	# MSN only.
	return "This command is only for MSN." unless $sender eq 'MSN';

	my $sn = $self->{Msn}->{Handle};
	$sn = lc($sn);
	$sn =~ s/ //g;

	my $msn = $chaos->{bots}->{$sn}->{client};

	# Must be a message.
	return "Give me a message to broadcast." unless length $msg > 0;

	my ($shout,$color) = split(/::/, $msg, 2);
	$color = '0000FF' unless length $color > 0;

	# Default font settings.
	my ($fontName,$fontColor,$fontStyle) = &get_font ($sn,'MSN');

	# Common colors.
	$color = '0000FF' if (length $color > 6 || $color =~ /[^A-Fa-f0-9]/i);
	$color = '0000FF' if $color eq 'red';
	$color = 'FF0000' if $color eq 'blue';
	$color = '00FF00' if $color eq 'lime';
	$color = 'FFFF00' if $color eq 'cyan';
	$color = 'FF00FF' if $color eq 'fuchsia';
	$color = 'CCCCCC' if $color eq 'white';
	$color = '999999' if $color =~ /^(grey|gray)$/i;
	$color = '000099' if $color eq 'berghundi';
	$color = '990000' if $color eq 'navy';
	$color = '009900' if $color eq 'green';
	$color = '999900' if $color eq 'teal';
	$color = '990099' if $color eq 'purple';
	$color = '000000' if $color eq 'black';
	$color = '0099FF' if $color eq 'orange';
	$color = 'FF9900' if $color eq 'skyblue';
	$color = $fontColor if $color eq 'default';

	# Broadcast.
	$msn->broadcast ("(*) Broadcast: $shout",
		Font   => 'Courier New',
		Color  => $color,
		Effect => 'B',
	);

	return "I have broadcasted the message.";
}
{
	Restrict    => 'Administrators',
	Category    => 'Administrator Commands',
	Description => 'Broadcast a message to all sockets.',
	Usage       => '!shout <message>[::color]',
	Listener    => 'MSN',
};