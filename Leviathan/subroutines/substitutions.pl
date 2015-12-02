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
# Description: Word substitutions.

sub substitutions {
	# Get variables from the shift.
	my $msg = shift;

	print "Debug // substitutions called!\n"
		. "\tmsg: $msg\n" if $chaos->{debug} == 1;

	# Get substitutin'! :P
	foreach my $key (keys %{$chaos->{system}->{substitution}}) {
		my $level = $chaos->{system}->{substitution}->{$key}->{level};
		my $replace = $chaos->{system}->{substitution}->{$key}->{replace};

		print "\t\tSubst. Key: $key\n"
			. "\t\t\tLevel: $level\n"
			. "\t\t\tReplace: $replace\n" if $chaos->{debug} == 1;

		$key =~ s/([^A-Za-z0-9 \_])/\\$1/ig;
		$replace =~ s/([^A-Za-z0-9 \_])/\\$1/ig;

		# Level 0: Replace Anywhere.
		# Level 1: Replace If Alone.

		if ($level == 1) {
			my @new;
			my @words = split(/\s+/, $msg);
			foreach my $word (@words) {
				$word = uc($word);

				if ($word eq $key) {
					$word = $replace;
				}

				push @new, $word;
			}

			$msg = join (" ", @new);
		}
		else {
			$msg =~ s/$key/$replace/ig;
		}

		print "\t\tMsg Now: $msg\n" if $chaos->{debug} == 1;
	}

	print "\tNew Msg: $msg\n\n" if $chaos->{debug} == 1;

	# Return the message.
	return $msg;
}
{
	Type        => 'subroutine',
	Name        => 'substitutions',
	Usage       => '$msg = &substitutions($msg)',
	Description => 'Word substitutions.',
	Author      => 'Cerone Kirsle',
	Created     => '4:21 PM 11/20/2004',
	Updated     => '4:21 PM 11/20/2004',
	Version     => '1.0',
};