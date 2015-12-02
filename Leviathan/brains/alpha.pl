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
#       Brain: Alpha
# Description: AiChaos' Alpha Brain.

sub alpha_get {
	# Incoming data for the brain.
	my ($brain,$self,$client,$msg,$omsg,$sn) = @_;

	$msg = lc($msg);

	# Echoing the bot?
	if (exists $chaos->{clients}->{$client}->{_alpha_last}) {
		if ($omsg eq $chaos->{clients}->{$client}->{_alpha_last}) {
			$msg = 'system echo';
			$omsg = $msg;
		}
	}

	# New user?
	$chaos->{clients}->{$client}->{_alpha_intro} ||= 0;
	if ($chaos->{clients}->{$client}->{name} eq $client && $chaos->{clients}->{$client}->{_alpha_intro} != 1) {
		$chaos->{clients}->{$client}->{_alpha_intro} = 1;
		$msg = 'system reg new user';
		$omsg = $msg;
	}

	# Input all kinds of variables.
	foreach my $var (keys %{$chaos->{clients}->{$client}}) {
		$chaos->{bots}->{$sn}->{_alpha}->set_variable ($var, $chaos->{clients}->{$client}->{$var});
	}

	# Input username and power variables.
	$chaos->{bots}->{$sn}->{_alpha}->set_variable ('username', $client);
	$chaos->{bots}->{$sn}->{_alpha}->set_variable ('master', &isMaster($client));
	$chaos->{bots}->{$sn}->{_alpha}->set_variable ('admin', &isAdmin($client));
	$chaos->{bots}->{$sn}->{_alpha}->set_variable ('mod', &isMod($client));

	# See how many words there are.
	my @words = split(/ /, $msg);
	if (scalar(@words) > 15) {
		$msg = 'system long message';
	}

	my $reply = $chaos->{bots}->{$sn}->{_alpha}->reply ($client,$msg);

	# If no reply was matched...
	if ($reply eq '<alphanoreplymatched>') {
		# Try the "noreply" reply.
		$reply = $chaos->{bots}->{$sn}->{_alpha}->reply ($client,'alphanoreplymatched');

		# Still no reply?
		if ($reply eq '<alphanoreplymatched>') {
			$reply = "ERROR: No reply matched.";
		}
	}

	# Clear variables.
	$chaos->{bots}->{$sn}->{_alpha}->clear_variables;

	# Special things in the replies.
	while ($reply =~ /\{>(.*?)\}/i) {
		my $save = $1;
		my ($var,$value) = split(/=/, $save, 2);
		$value = &formal($value) if $var =~ /^(name|location|book|band|spouse)$/i;
		&profile_send ($client,$var,$value);
		$chaos->{clients}->{$client}->{$var} = $value;
		$reply =~ s/\{>$save\}//i;
	}
	while ($reply =~ /\{<(.*?)\}/i) {
		my $what = $1;
		my $insert = $chaos->{clients}->{$client}->{$1} || 'ERR';
		$reply =~ s/\{<$what\}/$insert/i;
	}
	while ($reply =~ /\{\^(.*?)\}/i) {
		my $bot = $1;
		my $insert = $chaos->{bots}->{$sn}->{_data}->{$bot};
		$reply =~ s/\{\^$bot\}/$insert/i;
	}

	$chaos->{clients}->{$client}->{_alpha_last} = $reply;

	return $reply;
}
sub alpha_load {
	# Incoming data for the brain.
	my ($bot,$brain,$dir) = @_;

	use Chatbot::Alpha;

	# Create the Alpha brain.
	$chaos->{bots}->{$bot}->{_alpha} = new Chatbot::Alpha (
		debug => 0,
	);

	# Load the directory.
	$chaos->{bots}->{$bot}->{_alpha}->load_folder ($dir, 'txt');
	$chaos->{bots}->{$bot}->{_alpha}->load_folder ($dir, 'cba');

	# Set the default dumb reply.
	$chaos->{bots}->{$bot}->{_alpha}->default_reply ("<alphanoreplymatched>");

	# Sort replies.
	$chaos->{bots}->{$bot}->{_alpha}->sort_replies;

	# All done!
	return 1;
}
{
	Type           => 'brain',
	Name           => 'Alpha',
	Description    => 'AiChaos\' Alpha Brain.',
	RequireLoading => 1,
	LoadingSub     => 'alpha_load',
	ReplySub       => 'alpha_get',
	Author         => 'Cerone Kirsle',
	Created        => '2:53 PM 11/24/2004',
	Updated        => '2:53 PM 11/24/2004',
	Version        => '1.0',
};