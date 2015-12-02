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
#  Subroutine: scanDir
# Description: Scans a directory for a file extension (and can do recursion).

sub scanDir {
	# Directory data.
	my ($dir,$recurse,@ext) = @_;

	# $dir = directory to scan
	# $recurse = recursion (1 or 0)
	# @ext = list of file extensions.

	# List of all files.
	my @list = ();

	# Open the directory.
	opendir (DIR, "$dir");
	foreach my $file (sort(grep(!/^\./, readdir(DIR)))) {
		# Is this another directory?
		if (-d "$dir/$file") {
			# Recursing?
			if ($recurse) {
				# Get this directory too.
				my @subs = &scanDir("$dir/$file",1,@ext);
				push (@list,@subs);
				next;
			}
			else {
				next;
			}
		}

		my $good = 0;

		# Check the file type.
		foreach my $type (@ext) {
			if ($file =~ /$type$/i) {
				$good = 1;
			}
		}

		if (!@ext) {
			$good = 1;
		}

		# Good file?
		if ($good == 1) {
			push (@list,"$dir/$file");
		}
	}
	closedir (DIR);

	# Return the list.
	return @list;
}
{
	Type        => 'subroutine',
	Name        => 'isDir',
	Usage       => '(@paths) = &isDir($directory,$recurse,@extensions);',
	Description => 'Returns an array of file paths to all files of given @extensions.',
	Author      => 'Cerone Kirsle',
	Created     => '2:58 PM 3/16/2005',
	Updated     => '2:59 PM 3/16/2005',
	Version     => '1.0',
};