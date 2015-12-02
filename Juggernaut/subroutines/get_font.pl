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
#  Subroutine: get_font
# Description: Gets the bot's font settings.

sub get_font {
	# Get variables from the shift.
	my ($screenname,$listener) = @_;

	# Format the screenname.
	$screenname = lc($screenname);
	$screenname =~ s/ //g;

	# Load their font file.
	my $file = $chaos->{$screenname}->{font};
	open (FONT, "$file");
	my @data = <FONT>;
	close (FONT);
	chomp @data;

	# Go through the font.
	my %font;
	foreach $line (@data) {
		my ($what,$is) = split(/=/, $line, 2);
		$what = lc($what);
		$what =~ s/ //g;

		$font{$what} = $is;
	}

	# Create the font.
	if ($listener eq "AIM") {
		my $result = "<body bgcolor=\"$font{background}\" link=\"$font{link}\" vlink=\"$font{link}\">"
			. "<font face=\"$font{fontname}\" size=\"$font{size}\" color=\"$font{color}\">";
		$font{style} = lc($font{style});
		if ($font{style} =~ /bold/i) {
			$result .= "<b>";
		}
		if ($font{style} =~ /italic/i) {
			$result .= "<i>";
		}
		if ($font{style} =~ /under/i) {
			$result .= "<u>";
		}

		# Return the font.
		return $result;
	}
	elsif ($listener eq "MSN") {
		my $font_name = $font{fontface};
		my $font_color = $font{color};

		my $font_style;
		if ($font{style} =~ /bold/i) {
			$font_style .= "B";
		}
		if ($font{style} =~ /italic/i) {
			$font_style .= "I";
		}
		if ($font{style} =~ /under/i) {
			$font_style .= "U";
		}

		# If we don't have a font style.
		if ($font_style eq "") {
			$font_style = "R";
		}

		return ($font_name,$font_color,$font_style);
	}
	else {
		&panic ("A valid listener was not sent to get_font sub.", 0);
		return 0;
	}
}
1;