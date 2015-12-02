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
#       Brain: Guardians
# Description: AiChaos Guardians System.

sub guardians_message {
	# Incoming data for the brain.
	my ($brain,$self,$client,$msg,$omsg,$sn) = @_;

	$brain = lc($brain);
	$brain =~ s/ //g;
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Ignore this message if the user is not qualified.
	return '<noreply>' unless &isCks($client);

	my ($listener,$nick) = split(/\-/, $client, 2);

	# Commands.
	if ($msg =~ /^watch human (.*?)$/i) {
		my $user = $1;

		# AIM: Add this user under "Watch Humans"
		if ($listener eq 'AIM') {
			$self->add_buddy ("Watch Humans", $user);
			return "User added to buddylist.";
		}
		else {
			return "This messenger does not yet support watching humans.";
		}
	}
	elsif ($msg =~ /^suspend human (.*?)$/i) {
		my $user = $1;

		# AIM: Remove this user.
		if ($listener eq 'AIM') {
			$self->remove_buddy ("Watch Humans", $user);
			return "I have removed $user from my buddylist.";
		}
		else {
			return "This messenger does not yet support watching humans.";
		}
	}
	elsif ($msg =~ /^watch bot (.*?)$/i) {
		my $user = $1;

		# AIM: Add this user under "Watch Bots"
		if ($listener eq 'AIM') {
			$self->add_buddy ("Watch Bots", $user);
			return "User added to buddylist.";
		}
		else {
			return "This messenger does not yet support watching bots.";
		}
	}
	elsif ($msg =~ /^suspend bot (.*?)$/i) {
		my $user = $1;

		# AIM: Remove this user.
		if ($listener eq 'AIM') {
			$self->remove_buddy ("Watch Bots", $user);
			return "I have removed $user from my buddylist.";
		}
		else {
			return "This messenger does not yet support watching bots.";
		}
	}
	else {
		return "Guardian Commands:\n\n"
			. "watch human [username]\n"
			. "suspend human [username]\n"
			. "watch bot [username]\n"
			. "suspend bot [username]";
	}
}
sub guardians_init {
	# Initialization.
	my ($bot,$brain,$dir) = @_;

	# Start a queue going on an eternal loop.
	&queue ('_guardians', 10, '&guardians_active()');
}
sub guardians_active {
	# Activity sub.

	# Continue the loop.
	&queue ('_guardians', 10, '&guardians_active()');
}
sub guardian_botchat {
	# Chatting with a bot.

	# To do...
}
{
	Type           => 'brain',
	Name           => 'Guardians',
	Description    => 'AiChaos Guardians System.',
	RequireLoading => 1,
	LoadingSub     => 'guardians_init',
	ReplySub       => 'guardians_message',
	Author         => 'Cerone Kirsle',
	Created        => '8:57 PM 12/29/2004',
	Updated        => '8:57 PM 12/29/2004',
	Version        => '1.0',
};