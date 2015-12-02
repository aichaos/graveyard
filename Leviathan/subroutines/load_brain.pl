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
#  Subroutine: load_brain
# Description: Loads bot brains (only if their brains require loading).

sub load_brain {
	my ($bot,$brain,$reply) = @_;

	# Format the brain.
	$brain = lc($brain);
	$brain =~ s/ //g;

	print "Debug // Brain: $brain\n" if $chaos->{debug} == 1;

	# If it doesn't exist...
	return "That brain doesn't exist!" unless exists $chaos->{system}->{brains}->{$brain};

	# See if it requires loading...
	if ($chaos->{system}->{brains}->{$brain}->{RequireLoading} == 1) {
		# Load it!
		my $load_sub = $chaos->{system}->{brains}->{$brain}->{LoadingSub};

		return "Could not determine loading sub!" unless defined $load_sub;

		print "Calling loading sub \"$load_sub\"...\n" if $chaos->{debug} == 1;
		&{$load_sub} ($bot,$brain,$reply);
	}

	return 1;
}
{
	Type        => 'subroutine',
	Name        => 'load_brain',
	Usage       => '&load_brain ($screenname,$brain,$replies)',
	Description => 'Loads bot brains (only if their brains require loading).',
	Author      => 'Cerone Kirsle',
	Created     => '1:04 PM 11/20/2004',
	Updated     => '1:04 PM 11/20/2004',
	Version     => '1.0',
};