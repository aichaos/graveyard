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
# TOC Handler: chat_invite
# Description: Handles chat invitations.

sub toc_chat_invite {
	my ($aim,$evt) = @_;
	my ($name,$id,$client,$msg) = @{$evt->args};

	# Get localtime and username.
	my $stamp = &get_timestamp();
	my $sn = $aim->{botscreenname};
	$sn = lc($sn);
	$sn =~ s/ //g;

	print "$stamp\n"
		. "ChaosTOC: Received chat invitation.\n"
		. "\tRoom Name: $name\n"
		. "\t   ID No.: $id\n"
		. "\t     From: $client\n"
		. "\t       To: $sn\n";

	# Format the client.
	$client = lc($client);
	$client =~ s/ //g;
	$client = 'TOC-' . $client;

	# Chats allowed?
	if ($chaos->{bots}->{$sn}->{_chats}->{allow} == 0) {
		# Only accept invites from the master.
		if (&isMaster($client)) {
			# Accept.
			print "ChaosTOC: Accepting invite from master...\n\n";
			$aim->chat_accept ($id);
			return 1;
		}
		else {
			# Decline.
			print "ChaosTOC: Ignoring invitation (not allowed).\n\n";
			return 1;
		}
	}

	# Don't accept invites from blocked users or warners.
	if (&isBlocked($client) || &isWarner($client)) {
		print "ChaosTOC: Ignoring invitation (user is blocked).\n\n";
		return 1;
	}

	# Accept.
	print "ChaosTOC: Accepting invitation...\n";
	$aim->chat_accept ($id);
}
{
	Type        => 'handler',
	Name        => 'toc_chat_invite',
	Description => 'Handles chat invitations.',
	Author      => 'Cerone Kirsle',
	Created     => '12:55 PM 2/6/2005',
	Updated     => '12:55 PM 2/6/2005',
	Version     => '1.0',
};