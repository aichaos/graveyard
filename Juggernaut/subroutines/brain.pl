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
#  Subroutine: brain
# Description: The main brain of the bot.

sub brain {
	# Get variables from the shift.
	my ($self,$client,$listener,$msg,$omsg,$sn) = @_;

	my $date = localtime();
	my $secs = time();

	my $reply;
	my ($left,$center,$right);

	# Uppercase the message.
	$msg = &substitutions ($msg);
	$msg = uc($msg);
	$omsg = uc($omsg);
	my $found = 0;

	# Format some special cases, like HI could be matched in a series of messages.
	if ($msg eq "HI") {
		$msg = "HELLO";
	}

	# Log their last 10 messages.
	my ($i,$j);
	for ($i = 9; $i >= 1; $i--) {
		$j = $i + 1;
		$chaos->{_users}->{$client}->{_history}->{$j} = $chaos->{_users}->{$client}->{_history}->{$i};
		delete $chaos->{_users}->{$client}->{_history}->{$i};
	}
	$chaos->{_users}->{$client}->{_history}->{1} = $msg;

	# See if they're repeating themselves...
	my $a = $chaos->{_users}->{$client}->{_history}->{1};
	my $b = $chaos->{_users}->{$client}->{_history}->{2};
	my $c = $chaos->{_users}->{$client}->{_history}->{3};
	my $d = $chaos->{_users}->{$client}->{_history}->{4};
	my $e = $chaos->{_users}->{$client}->{_history}->{5};
	my $f = $chaos->{_users}->{$client}->{_history}->{6};
	my $g = $chaos->{_users}->{$client}->{_history}->{7};
	my $h = $chaos->{_users}->{$client}->{_history}->{8};
	$i = $chaos->{_users}->{$client}->{_history}->{9};
	$j = $chaos->{_users}->{$client}->{_history}->{10};

	# First 7, get a warning.
	if (length $a > 0 && $a eq $b && $a eq $c && $a eq $d && $a eq $e && $a eq $f && $a eq $g) {
		$msg = 'SYSTEM REPEAT WARNING';
	}

	# All 10, blocked for 24 hours.
	if (length $a > 0 && $a eq $b && $a eq $c && $a eq $d && $a eq $e && $a eq $f && $a eq $g && $a eq $h && $a eq $i && $a eq $j) {
		$msg = 'SYSTEM REPEAT BAN';
		&system_block ($client,$listener,24);
	}

	# Get the reply.
	$reply = &get_reply ($chaos->{$sn}->{brain},$self,$client,$listener,$msg,$omsg,$sn);

	return $reply;
}
1;