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
# AIM Handler: chat_invite
# Description: Handles chat invitations.

sub aim_chat_invite {
	my ($aim,$client,$msg,$chat,$url) = @_;

	# Get some data.
	my $screenname = $aim->screenname();
	my $time = &get_timestamp();

	my $sn = lc($screenname);
	$sn =~ s/ //g;

	print "$time\n"
		. "ChaosAIM: Received Chat Invitation\n"
		. "\t     To: $screenname\n"
		. "\t   From: $client\n"
		. "\tMessage: $msg\n"
		. "\t   Room: $chat\n";

	# Format the client.
	$client = lc($client);
	$client =~ s/ //g;
	$client = 'AIM-' . $client;

	# If chat invites are blocked...
	if ($chaos->{bots}->{$sn}->{_chats}->{allow} == 0) {
		# Only accept if it's from the master.
		if (&isMaster($client)) {
			# Accept.
			print "ChaosAIM: Accepting invitation from master...\n\n";
			$aim->chat_accept ($url);
			return 1;
		}
		else {
			# Decline.
			print "ChaosAIM: Declining invitation (not allowed).\n\n";
			$aim->chat_decline ($url);
			return 1;
		}
	}

	# Don't accept invites from blocked users or warners.
	if (isBlocked($client) || isWarner($client)) {
		print "ChaosAIM: Declining invitation (user is blocked).\n\n";
		$aim->chat_decline ($url);
		return 1;
	}
	else {
		print "ChaosAIM: Accepting invitation...\n\n";
	}

	# Accept the invitation.
	$aim->chat_accept ($url);
}
{
	Type        => 'handler',
	Name        => 'aim_chat_invite',
	Description => 'Handles chat invitations.',
	Author      => 'Cerone Kirsle',
	Created     => '2:43 PM 11/20/2004',
	Updated     => '2:43 PM 11/20/2004',
	Version     => '1.0',
};