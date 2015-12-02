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
# Description: AiChaos' Chaos Markup Language 2.0

sub chaosml_get {
	# Incoming data for the brain.
	my ($brain,$self,$client,$msg,$omsg,$sn) = @_;

	$brain = lc($brain);
	$brain =~ s/ //g;
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Get the <that> and/or topic.
	my $that  = $chaos->{clients}->{$client}->{_chaosml}->{that};
	my $topic = $chaos->{clients}->{$client}->{_chaosml}->{topic};

	$msg = uc($msg);

	print "Debug // Msg: $msg\n"
		. "\tOMSG: $omsg\n\n";

	# Get a reply.
	my ($reply,$out) = $chaos->{bots}->{$sn}->{_chaosml}->cml_response ($msg,
		topic => $topic,
		that  => $that,
	);

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
	my ($lsecs,$lmin,$lhour,$lmday,$lmon,$lyear,$lwday,$lyday,$lisdst) = localtime(time());
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
		&profile_send ($client,$c,$d);
		$reply =~ s/<set>$a<\/set>/$d/ig;
	}
	while ($reply =~ /<get>(.*?)<\/get>/i) {
		# Get a User Variable
		$a = $1;

		# A = The variable name to get.

		# Do what you want with these.
		$reply =~ s/<get>$a<\/get>/$chaos->{clients}->{$client}->{$a}/i;
	}
	while ($reply =~ /<bot>(.*?)<\/bot>/i) {
		# Get a Bot Variable
		$a = $1;

		# A = The variable name to get.

		# Do what you want with these.
		$reply =~ s/<bot>$a<\/bot>/$chaos->{bots}->{$sn}->{data}->{$a}/i;
	}
	while ($reply =~ /<settopic=(.*?)>/i) {
		# Set the Topic
		$a = $1;
		$a = uc($a);

		# A = The topic to set to.

		if ($a eq 'RANDOM') {
			delete $chaos->{clients}->{$client}->{_chaosml}->{topic};
		}
		else {
			$chaos->{clients}->{$client}->{_chaosml}->{topic} = $a;
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
	$chaos->{clients}->{$client}->{_chaosml}->{that} = $out;

	return $reply;
}
sub chaosml_load {
	# Incoming data for the brain.
	my ($bot,$brain,$dir) = @_;

	use CML;

	# Create the CML object.
	$chaos->{bots}->{$bot}->{_chaosml} = new CML ();

	print "Bot: $bot\n"
		. "Brain: $brain\n"
		. "Dir: $dir\n\n";

	# Load the folder.
	my ($load,@files) = $chaos->{bots}->{$bot}->{_chaosml}->load_folder ($dir, 'cml');

	# Errors?
	if ($load == 1) {
		if (scalar(@files) > 0) {
			&panic ("ChaosML: Error 1 Bad or Corrupted Files:\n"
				. "\t" . join ("\n\t", @files), 0);
		}
	}
	elsif ($load == 2) {
		&panic ("ChaosML: Error 2 Folder \"$dir\" Did Not Exist!",1);
	}
	elsif ($load == 3) {
		&panic ("ChaosML: Error 3 No CML Files Found!",1);
	}

	# All done!
	return 1;
}
{
	Type           => 'brain',
	Name           => 'ChaosML',
	Description    => 'AiChaos\' Chaos Markup Language 2.0',
	RequireLoading => 1,
	LoadingSub     => 'chaosml_load',
	ReplySub       => 'chaosml_get',
	Author         => 'Cerone Kirsle',
	Created        => '3:00 PM 11/24/2004',
	Updated        => '3:00 PM 11/24/2004',
	Version        => '1.0',
};