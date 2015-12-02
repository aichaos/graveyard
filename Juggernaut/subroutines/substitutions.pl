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
#  Subroutine: substitutions
# Description: Makes substitutions and spelling corrections.

sub substitutions {
	# Get variables from the shift.
	my $msg = shift;

	# Get substitutin'! :P
	foreach my $key (keys %{$chaos->{_system}->{substitution}}) {
		my $level = $chaos->{_system}->{substitution}->{$key}->{level};
		my $replace = $chaos->{_system}->{substitution}->{$key}->{replace};

		# Level 0: Replace Anywhere.
		# Level 1: Replace If Alone.

		if ($level == 0) {
			$msg =~ s/$key/$replace/ig;
		}
		elsif ($level == 1) {
			my @new;
			my @words = split(/\s+/, $msg);
			foreach my $word (@words) {
				$word = lc($word);

				if ($word eq $key) {
					$word = $replace;
				}

				push @new, $word;
			}

			$msg = join (" ", @new);
		}
		else {
			&panic ("Unknown level in substitutions.pl", 0);
		}
	}

	# Return the message.
	return $msg;
}
1;