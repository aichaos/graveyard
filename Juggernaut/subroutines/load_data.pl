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
#  Subroutine: load_data
# Description: Loads default userdata (such as blocks).

sub load_data {
	# Blocks are loaded no matter what ya do. But set this variable
	# to 1 if you want all userdata to be loaded as well (might
	# eat up some memory, don't know, haven't tested it).
	my $load_clients = 1;

	# Load the blocks.
	opendir (BLOCK, "./data/blocks") or panic ("Could not open blocks directory!",0);
	foreach my $block (sort(grep(!/^\./, readdir(BLOCK)))) {
		$block =~ s/\.txt$//ig;

		my ($block_listener,$block_name) = split(/\-/, $block, 2);
		open (DATA, "./data/blocks/$block\.txt") or panic ("Could not open $block.txt (block)!",0);
		my $expire = <DATA>;
		close (DATA);

		# The block key.
		my $key = lc($block_listener) . '-' . lc($block_name);

		# Put the key into the hash.
		$chaos->{_data}->{blocks}->{$key} = $expire;
	}
	closedir (BLOCK);

	# Load all client data? (This may eat up a lot of memory)
	if ($load_clients) {
		# Open the clients directory.
		opendir (CLIENTS, "./clients");
		foreach my $file (sort(grep(!/^\./, readdir (CLIENTS)))) {
			next if (-d "./clients/$file");
			$file =~ s/\.txt$//ig;

			my ($listener,$username) = split(/\-/, $file, 2);
			$listener = uc($listener);
			$listener =~ s/ //g;
			$username = lc($username);
			$username =~ s/ //g;

			if ($listener eq 'IRC') {
				$username = 'IRC_' . $username;
			}

			open (CLIENT, "./clients/$file\.txt") or panic ("Could not open $file.txt (client)!",0);
			my @data = <CLIENT>;
			close (CLIENT);	
			chomp @data;

			foreach my $line (@data) {
				my ($what,$is) = split(/=/, $line, 2);
				$what = lc($what);
				$what =~ s/ //g;

				$chaos->{_users}->{$username}->{$what} = $is;
			}
		}
		closedir (CLIENTS);
	}

	# Return true.
	return 1;
}
1;