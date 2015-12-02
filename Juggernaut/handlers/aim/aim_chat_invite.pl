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
# AIM Handler: aim_chat_invite
# Description: Handles incoming chat invitations.

sub aim_chat_invite {
	# Get variables from the server.
	my ($aim,$client,$msg,$chat,$url) = @_;

	print "ChaosAIM: Chat Invite\n";

	my $screenname = $aim->screenname();
	$screenname = lc($screenname);
	$screenname =~ s/ //g;
	my $time = localtime();

	# Print this invitation.
	print "ChaosAIM: Recieved Chat Invitation\n"
		. "\tTo: $screenname\n"
		. "\tFrom: $client\n"
		. "\tMessage: $msg\n"
		. "\tRoom: $chat\n";

	# Don't accept invites from blocked users or warners.
	if (isBlocked($client,"AIM") || isWarner($aim,$client,"AIM",1)) {
		print "ChaosAIM: Denying invitation (user is blocked).\n\n";
		$aim->chat_decline ($url);
		return 1;
	}

	# If we're not allowed to join other chats...
	if ($chaos->{$screenname}->{_chats}->{allow} == 1) {
		print "ChaosAIM: Denying invitation (not allowed).\n\n";
		$aim->chat_decline ($url);
		return 1;
	}
	else {
		print "ChaosAIM: Accepting invitation...\n\n";
	}

	# Format the room name and set the topic (if it doesn't exist yet).
	$chat = lc($chat);
	$chat =~ s/ //g;

	# Add this to our list of room names.
	$screenname = lc($screenname);
	$chaos->{$screenname}->{chats} .= "$chat,";

	# Accept the invitation.
	$aim->chat_accept ($url);
}
1;