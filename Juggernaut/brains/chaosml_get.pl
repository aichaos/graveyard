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
#       Brain: ChaosML
#    Sub-Type: GET
# Description: Get a response from the CML 2.0 brain.

sub chaosml_get {
	# Incoming data for the brain.
	my ($brain,$self,$client,$listener,$msg,$omsg,$sn) = @_;

	# Use CML::Util for some general utilities later on.
	use CML::Util;

	$brain = lc($brain);
	$brain =~ s/ //g;

	$sn = lc($sn);
	$sn =~ s/ //g;

	# Get the <that> response and/or topic.
	my $that = $chaos->{_users}->{$client}->{_chaosml}->{that};
	my $topic = $chaos->{_users}->{$client}->{_chaosml}->{topic};

	# Get a response.
	my ($reply,$out) = $chaos->{$sn}->{_data}->{brain}->cml_response ($msg,
		topic => $topic,
		that => $that,
	) or return "Could not get reply!";

	# Get the local date.
	my @months = (
		'January',
		'February',
		'March',
		'April',
		'May',
		'June',
		'July',
		'August',
		'September',
		'October',
		'November',
		'December',
	);
	my @days = (
		'Sunday',
		'Monday',
		'Tuesday',
		'Wednesday',
		'Thursday',
		'Friday',
		'Saturday',
	);
	my ($lsecs,$lmin,$lhour,$lmday,$lmon,$lyear,$lwday,$lyday,$lisdst) = localtime(time);
	$lyear += 1900;
	$lsecs = '0' . $lsecs if length $lsecs == 1;
	my $lext = 'AM';
	$lext = 'PM' if $lhour >= 12;
	my $hour12 = $lhour;
	$hour12 -= 12 if $hour12 > 12;

	# Set some things.
	my $date = "$days[$lwday], $months[$lmon] $lmday $lyear";
	my $time = "$hour12:$lmin $lext";

	# Filter the responses.
	my ($a,$b,$c,$d);

	# Small One-Liners
	$reply =~ s/<date>/$date/ig;
	$reply =~ s/<time>/$time/ig;
	$reply =~ s/<client>/$client/ig;
	$reply =~ s/<listener>/$listener/ig;
	$reply =~ s/<sn>/$sn/ig;
	$reply =~ s/<nextreply>/<:>/ig;
	$reply =~ s/<think>/<!--/ig;
	$reply =~ s/<\/think>/-->/ig;

	while ($reply =~ /<set>(.*?)<\/set>/i) {
		# Setting a User Variable
		$a = $1;
		($b,$c,$d) = split(/\=/, $a, 3);

		print "Debug // Set: b = $b, c = $c, d = $d\n";

		# B = Type, C = Variable, D = Value
		if ($b =~ /^formal$/i) {
			$d = CML::Util::formal ($d);
		}

		# Do what you want with these.
		&profile_send ($client,$listener,$c,$d);
		$reply =~ s/<set>$a<\/set>/$d/ig;
	}
	while ($reply =~ /<get>(.*?)<\/get>/i) {
		# Get a User Variable
		$a = $1;

		# A = The variable name to get.

		# Do what you want with these.
		$reply =~ s/<get>$a<\/get>/$chaos->{_users}->{$client}->{$a}/i;
	}
	while ($reply =~ /<bot>(.*?)<\/bot>/i) {
		# Get a Bot Variable
		$a = $1;

		# A = The variable name to get.

		# Do what you want with these.
		$reply =~ s/<bot>$a<\/bot>/$chaos->{$sn}->{data}->{$a}/i;
	}
	while ($reply =~ /<settopic=(.*?)>/i) {
		# Set the Topic
		$a = $1;
		$a = uc($a);

		# A = The topic to set to.

		if ($a eq 'RANDOM') {
			delete $chaos->{_users}->{$client}->{_chaosml}->{topic};
		}
		else {
			$chaos->{_users}->{$client}->{_chaosml}->{topic} = $a;
		}

		$reply =~ s/<settopic=(.*?)>/$a/i;
	}
	while ($reply =~ /<formal>(.*?)<\/formal>/i) {
		# A Formal String
		$a = $1;
		$a = CML::Util::formal ($a);
		$reply =~ s/<formal>(.*?)<\/formal>/$a/i;
	}
	while ($reply =~ /<sentence>(.*?)<\/sentence>/i) {
		# A sentence-cased string.
		$a = $1;
		$a = CML::Util::sentence ($a);
		$reply =~ s/<sentence>(.*?)<\/sentence>/$a/i;
	}
	while ($reply =~ /<random>(.*?)<\/random>/i) {
		# Sub-Random Variables
		$a = $1;

		my @rand;
		@rand = split(/\ /, $a) unless $a =~ /\,/;
		@rand = split(/\,/, $a) if $a =~ /\,/;

		$b = $rand [ int(rand(scalar(@rand))) ];

		# Do what you want with these.
		$reply =~ s/<random>$a<\/random>/$b/i;
	}
	while ($reply =~ /<system>(.*?)<\/system>/i) {
		# System Methods.
		$a = $1;

		# A = The code to evaluate.

		# Do what you want with these.
		eval ($a);

		# Remove that.
		$reply =~ s/<system>/<!--/i;
		$reply =~ s/<\/system>/-->/i;
	}

	# Save the <that> in this user's data.
	$chaos->{_users}->{$client}->{_chaosml}->{that} = $out;

	return $reply;
}
1;