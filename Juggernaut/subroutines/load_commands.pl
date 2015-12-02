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
#  Subroutine: load_commands
# Description: Loads all the commands into a hash.

sub load_commands {
	# Open the commands folder.
	my $void;
	opendir (DIR, "./commands");
	foreach my $file (sort(grep(!/^\./, readdir (DIR)))) {
		# If this is a folder...
		if (-d "./commands/$file") {
			# Go one level deep, and continue.
			opendir (TWO, "./commands/$file");
			foreach my $two (sort(grep(!/^\./, readdir(TWO)))) {
				# Only Perl files this time.
				next unless $two =~ /\.pl$/i;
				($two,$void) = split(/\./, $two, 2);
				$two = lc($two);
				$two =~ s/ //g;

				# If we've already loaded this command...
				if (exists $chaos->{_system}->{commands}->{$two}) {
					$chaos->{_system}->{commands}->{$two} = do "./commands/$file/$two\.pl";
				}
				else {
					$chaos->{_system}->{commands}->{$two} = require "./commands/$file/$two\.pl";
				}
			}
			closedir (TWO);
		}
		else {
			# Only Perl files.
			next unless $file =~ /\.pl$/i;
			($file,$void) = split(/\./, $file, 2);
			$file = lc($file);
			$file =~ s/ //g;

			# If we've already loaded this command...
			if (exists $chaos->{_system}->{commands}->{$file}) {
				$chaos->{_system}->{commands}->{$file} = do "./commands/$file\.pl";
			}
			else {
				$chaos->{_system}->{commands}->{$file} = require "./commands/$file\.pl";
			}
		}
	}
	closedir (DIR);

	my $count = 0;
	foreach my $key (keys %{$chaos->{_system}->{commands}}) {
		$count++;
	}

	# Save our command count.
	$chaos->{_data}->{commandcount} = $count;

	# We now have all the commands loaded.
}
1;