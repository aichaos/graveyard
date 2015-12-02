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
# TOC Handler: chat_update_buddy
# Description: Handles chat buddy updates.

sub toc_chat_update_buddy {
	my ($aim,$evt) = @_;
	my ($id,$inside,@users) = @{$evt->args};

	# Get localtime and username.
	my $stamp = &get_timestamp();
	my $sn = $aim->{botscreenname};
	$sn = lc($sn);
	$sn =~ s/ //g;

	my $room = $aim->get_roomname($id);
	my %act = (
		'T' => 'entered',
		'F' => 'left',
	);

	print "$stamp\n";
	foreach my $user (@users) {
		print "ChaosTOC: $user has $act{$inside} $room\n";
	}
}
{
	Type        => 'handler',
	Name        => 'toc_chat_update_buddy',
	Description => 'Handles chat buddy updates.',
	Author      => 'Cerone Kirsle',
	Created     => '12:58 PM 2/6/2005',
	Updated     => '12:58 PM 2/6/2005',
	Version     => '1.0',
};