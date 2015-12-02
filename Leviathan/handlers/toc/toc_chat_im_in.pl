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
# TOC Handler: chat_im_in
# Description: Handles chat instant messages.

sub toc_chat_im_in {
	my ($aim,$evt) = @_;
	my ($id,$client,$whisper,$msg) = @{$evt->args};

	# Get localtime and username.
	my $stamp = &get_timestamp();
	my $sn = $aim->{botscreenname};
	$sn = lc($sn);
	$sn =~ s/ //g;

	my $action = 'said';
	$action = 'whispered' if $whisper eq 'T';
	my $room = $aim->get_roomname($id);
	$msg =~ s/<(.|\n)+?>//g;

	if ($msg =~ /^$sn leave/i) {
		# Leave the room.
		$aim->chat_leave($id);
	}

	print "$stamp\n"
		. "ChaosTOC: <Chat Room: $room>\n"
		. "[TOC-$client] $msg\n\n";
}
{
	Type        => 'handler',
	Name        => 'toc_chat_im_in',
	Description => 'Handles chat instant messages.',
	Author      => 'Cerone Kirsle',
	Created     => '1:07 PM 2/6/2005',
	Updated     => '1:07 PM 2/6/2005',
	Version     => '1.0',
};