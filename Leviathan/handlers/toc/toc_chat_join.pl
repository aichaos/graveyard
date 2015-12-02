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
# TOC Handler: chat_join
# Description: Called when you enter a chat.

sub toc_chat_join {
	my ($aim,$evt) = @_;
	my ($id,$name) = @{$evt->args};

	# Get localtime and username.
	my $stamp = &get_timestamp();
	my $sn = $aim->{botscreenname};
	$sn = lc($sn);
	$sn =~ s/ //g;

	print "$stamp\n"
		. "ChaosTOC: Joined room $name.\n\n";

}
{
	Type        => 'handler',
	Name        => 'toc_chat_join',
	Description => 'Called when you enter a chat.',
	Author      => 'Cerone Kirsle',
	Created     => '12:56 PM 2/6/2005',
	Updated     => '12:56 PM 2/6/2005',
	Version     => '1.0',
};