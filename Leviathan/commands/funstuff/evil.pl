#      .   .               <Leviathan>
#     .:...::     Command Name // !evil
#    .::   ::.     Description // Evil way to issue commands.
# ..:;;. ' .;;:..        Usage // !evil
#    .  '''  .     Permissions // Public.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub evil {
	my ($self,$client,$msg) = @_;

	# Needs a message.
	return "Give me an order when using this command, i.e.\n\n"
		. "!evil Sign my guestbook" if length $msg == 0;

	$msg = lc($msg);
	my $first = ucfirst($msg);

	# Arrays.
	my @start = (
		"<first>, mortal, ",
		"<first>, thou puny mortal, ",
		"<first>, thou mortal, ",
		"<first>, human, ",
		"<first>, slave, ",
		"<first>, thou puny human, ",
		"<first>, thou human, ",
	);
	my @main = (
		"or suffer an eternity of pain and torture such as no mortal hath ever experienced before or shalt ever experience again. ",
		"or be sentenced thee to a life of everlasting bankruptcy. ",
		"or live for six hundred and sixty six years the life of a flea. ",
		"or be sentenced to forty years on the Island of Perpetual Tickling. ",
		"or be glued to the ground when Hell freezeth over. ",
		"or feel the full weight of the humans' sins upon thy shoulders. ",
		"or abandon thy life thou hast known, and live eternally as my minion. ",
		"and conform to my will. ",
		"and abandon thee the very thing that makes thee human. ",
	);
	my @last = (
		"To avoid thee this insufferable fate, <order>!",
		"To be spared thee this inhumane destiny, <order>!",
		"So <order> if thou wanteth but to live.",
		"To avoid thee this horrible punishment, <order>!",
		"To escape thee my wrath, <order>!",
		"If thou expecteth to see the light of day, follow my orders and <order>!",
	);

	# Generate the sentence parts.
	my $a = $start [ int(rand(scalar(@start))) ];
	my $b = $main [ int(rand(scalar(@main))) ];
	my $c = $last [ int(rand(scalar(@last))) ];

	my $final = CORE::join ("", $a, $b, $c);
	$final =~ s/<first>/$first/ig;
	$final =~ s/<order>/$msg/ig;

	return "<font color=\"#FF0000\">$final</font>";
}
{
	Category    => 'Fun Stuff',
	Description => 'Evil way to issue commands.',
	Usage       => '!evil <order>',
	Listener    => 'All',
};