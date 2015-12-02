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
# Description: Returns the bot's font settings.

sub get_font {
	# Get variables from the shift.
	my ($screenname,$listener) = @_;

	# Format the screenname.
	$screenname = lc($screenname);
	$screenname =~ s/ //g;

	# Default font settings.
	my %def = (
		# AIM-Specific
		'background' => '#000000',
		'link'       => '#0000FF',
		'vlink'      => '#0000FF',

		# General
		'fontname'   => 'Verdana',
		'size'       => '2',
		'color'      => '#000000',
		'style'      => '',
		'smileys'    => '',
	);
	$def{color} = '000000' if $listener eq 'MSN';

	# Load their font file.
	my $file = $chaos->{bots}->{$screenname}->{font};
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

	# Revert to defaults?
	foreach my $item (keys %def) {
		if (exists $font{$item} && length $font{$item} == 0) {
			$font{$item} = $def{$item};
		}
	}

	# Create the font.
	if ($listener eq "AIM" || $listener eq "TOC") {
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

		return ($result,$font{smileys});
	}
	elsif ($listener eq "YAHOO") {
		my $font_name = $font{fontname};
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

		return ($font_name,$font_color,$font_style);
	}
	elsif ($listener eq "MSN") {
		my $font_name = $font{fontname};
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

		return ($font_name,$font_color,$font_style);
	}
	else {
		&panic ("A valid listener was not sent to get_font sub.", 0);
		return 0;
	}
}
{
	Type        => 'subroutine',
	Name        => 'get_font',
	Usage       => '&get_font($screenname,$listener)',
	Description => 'Returns the bot\'s font settings.',
	Author      => 'Cerone Kirsle',
	Created     => '3:36 PM 11/20/2004',
	Updated     => '3:36 PM 11/20/2004',
	Version     => '1.0',
};