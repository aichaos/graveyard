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
# TOC Handler: error
# Description: Handles errors.

sub toc_error {
	my ($aim,$evt) = @_;
	my ($error,@staff) = @{$evt->args};

	# Get localtime and username.
	my $stamp = &get_timestamp();
	my $sn = $aim->{botscreenname};
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Translate the error to English.
	my $string = $evt->trans($error);
	$string =~ s/\$[\d+]/$stuff[$1]/ge;

	print "$stamp\n"
		. "ChaosTOC: Error: $string\n\n";
}
{
	Type        => 'handler',
	Name        => 'toc_error',
	Description => 'Handles TOC errors.',
	Author      => 'Cerone Kirsle',
	Created     => '12:44 PM 2/6/2005',
	Updated     => '12:44 PM 2/6/2005',
	Version     => '1.0',
};